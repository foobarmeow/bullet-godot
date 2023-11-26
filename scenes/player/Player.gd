class_name Player extends CharacterBody2D

signal parry

@export var speed = 125
@export var acceleration = 25
@export var deceleration = 50
@export var top_speed = 150
@export var parry_time: float = 1.5

var sprite: AnimatedSprite2D
var last_parried: Node2D
var parried: bool = false
var dead: bool = false


# TODO: Make this a property of the node that collided
var damage: int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	if $AnimatedSprite2D == null:
		print_debug("no sprite bruh")
		return			
	sprite = $AnimatedSprite2D

func _unhandled_input(_event):
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
		return
	if Input.is_action_just_pressed("parry"):
		_parry()
		return

func _parry():
	if parried: 
			return
	var overlaps = $Parry.get_overlapping_bodies()
	if len(overlaps) < 1:
		parried = false
		return
	var first_overlap = overlaps.pop_at(0)
	if first_overlap.has_method("parry"):
		first_overlap.parry()
		last_parried = first_overlap
	
	for o in overlaps:
		# destroy the rest, that is the power of the light
		if o.has_method("destroy"):
			o.destroy()
	
	parried = true
	$KillLight.activate()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if dead:
		return
	if Input.is_action_pressed("move_right"):
		sprite.flip_h = false
	if Input.is_action_pressed("move_left"):
		sprite.flip_h = true
		
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = velocity.move_toward(input_direction * speed, acceleration)
	sprite.play("walk")

	if velocity.length() == 0:
		sprite.play("idle")
		velocity = velocity.move_toward(Vector2.ZERO, deceleration)
	move_and_collide(velocity * delta)
	
# Called by bullets that detect collision with player
func take_damage(d: int, enemy: Node2D):
	if enemy == last_parried: 
		return
	
	var dmgmgr = $DamageManager
	if dmgmgr:
		dmgmgr.take_damage(self, enemy, d)

func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "dead":
		process_mode = Node.PROCESS_MODE_DISABLED

func _on_kill_light_parry_recharged():
	parried = false

func _on_damage_manager_health_updated(health: int):
	if health <= 0:
		dead = true
		sprite.play("dead")

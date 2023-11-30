class_name Player extends CharacterBody2D

signal parry
signal died

@export var speed = 125
@export var acceleration = 25
@export var deceleration = 50
@export var top_speed = 150
@export var parry_time: float = 1.5
@export var dash_multiplier: int = 100
@export var dash_time: float = .2
@export var can_parry: bool:
	set(v):
		can_parry = v

var sprite: AnimatedSprite2D
var last_parried: Node2D
var parried: bool = false
var dead: bool = false
var parry_outside_edge_distance: float


# TODO: Make this a property of the node that collided
var damage: int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	if can_parry:
		pass
		#$ParryRing.show()
	else:
		$ParryRing.hide()
	if $AnimatedSprite2D == null:
		print_debug("no sprite bruh")
		return			
	sprite = $AnimatedSprite2D
	parry_outside_edge_distance = Vector2.ZERO.distance_to($ParryMeasurementLine.points[2])
	print(parry_outside_edge_distance)

func _unhandled_input(_event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_parry()
		return
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
		return
	if Input.is_action_just_pressed("parry"):
		_parry()
		return
	if Input.is_action_just_pressed("dash"):
		_dash()
		return


var parry_debug_lines = []
func _parry():
	if parried || !can_parry: 
			return
	var overlaps = $ParryArea.get_overlapping_bodies()
	if len(overlaps) < 1:
		print("no overlaps")
		parried = false
		return

	for l in parry_debug_lines:
		l.queue_free()
		
	parry_debug_lines = []

	var anyParried = false
	for o in overlaps:
		var diff = position.distance_to(o.position)
		var diff_from_outside = diff - parry_outside_edge_distance
		
		if $Shield.check_position(o.global_position, o.get_width()):
			if o.has_method("parry"):
				o.parry(false)
				last_parried = o

#	var first_overlap = overlaps.pop_at(0)
#	if first_overlap.has_method("parry"):
#		first_overlap.parry()
#		last_parried = first_overlap
#
#	for o in overlaps:
#		# destroy the rest, that is the power of the light
#		if o.has_method("destroy"):
#			o.destroy()
#
	#sparried = true
	$ParryRing.activate()
	

var dash = false
func _dash():
	if dash:
		return
	set_collision_mask_value(7, false)
	dash = true
	_on_damage_manager_invuln_updated(true)
	await get_tree().create_timer(dash_time).timeout
	dash = false
	_on_damage_manager_invuln_updated(false)
	set_collision_mask_value(7, true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if dead:
		return
	if Input.is_action_pressed("move_right"):
		sprite.flip_h = false
	if Input.is_action_pressed("move_left"):
		sprite.flip_h = true
		
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if dash:
		input_direction = input_direction * dash_multiplier
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
	$BytesAnimator.play("hit-byte")
	var dmgmgr = $DamageManager
	if dmgmgr:
		dmgmgr.take_damage(self, enemy, d)


func _on_kill_light_parry_recharged():
	parried = false

func _on_damage_manager_health_updated(health: int, _init_health: int):
	if health <= 0:
		dead = true
		sprite.play("dead")
		died.emit()


func _on_damage_manager_invuln_updated(invuln: bool):
	print("INVULN")
	if invuln:
		$AnimationPlayer.play("invuln_blink")
		set_collision_layer_value(2, false)
	else:
		$AnimationPlayer.stop()
		set_collision_layer_value(2, true)

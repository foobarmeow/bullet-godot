class_name Player extends CharacterBody2D

signal parry
signal died
signal level_action


@export var speed = 125
@export var acceleration = 25
@export var deceleration = 50
@export var top_speed = 150

@export var dash_multiplier: int = 100
@export var dash_time: float = .2

@export var has_weapon: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var dead: bool = false
var drinkable: bool = false

func _unhandled_input(_event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		fire()
		return
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
		return
	if Input.is_action_just_pressed("dash"):
		_dash()
		return


func fire():
	if has_weapon && $Weapon:
		$Weapon.fire()

# local variable for whether or not we're dashing
var dash = false
func _dash():
	if dash:
		return
		
	# We don't collide with ledges while dashing
	set_collision_mask_value(7, false)
	dash = true
	handle_invuln(true, true)
	await get_tree().create_timer(dash_time).timeout
	dash = false
	handle_invuln(false, false)
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
	var coll = move_and_collide(velocity * delta)
	if coll:
		if coll.get_collider().is_in_group("walls"):
			#velocity = velocity.bounce(coll.get_normal()) * .5
			velocity = velocity.slide(coll.get_normal())
			print(coll)
	
# Called by bullets that detect collision with player
func take_damage(d: int, enemy: Node2D):
	$BytesAnimator.play("hit-byte")
	var dmgmgr = $DamageManager
	if dmgmgr:
		dmgmgr.take_damage(self, enemy, d)
		
func handle_invuln(invuln: bool, is_dash: bool):
	var animation_name = "invuln_blink"
	if is_dash:
		animation_name = "dash_blink"
	
	# We don't exist on player layer while invulnerable
	if invuln:
		$AnimationPlayer.play(animation_name)
		set_collision_layer_value(2, false)
	else:
		$AnimationPlayer.stop()
		set_collision_layer_value(2, true)


func _on_damage_manager_health_updated(health: int, _init_health: int):
	if health <= 0:
		dead = true
		sprite.play("dead")
		died.emit()

func _on_damage_manager_invuln_updated(_invuln: bool):
	handle_invuln(true, false)

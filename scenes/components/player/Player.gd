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
@onready var dmg: DamageManager = $DamageManager

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

	# Handle collision before setting velocity
	var coll = move_and_collide(velocity * delta)
	if coll:
		if coll.get_collider().is_in_group("walls"):
			velocity = velocity.slide(coll.get_normal())
			return
		if coll.get_collider().is_in_group("rocks"):
			take_damage(10, coll.get_collider())
			return


	
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if dash:
		input_direction = input_direction * dash_multiplier
	velocity = velocity.move_toward(input_direction * speed, acceleration)
	sprite.play("walk")

	if velocity.length() == 0:
		sprite.play("idle")
		velocity = velocity.move_toward(Vector2.ZERO, deceleration)
	
# Called by bullets that detect collision with player
func take_damage(d: int, enemy: Node2D):
	$BytesAnimator.play("hit-byte")
	dmg.take_damage(self, enemy, d)
		
func handle_invuln(invuln: bool, is_dash: bool):
	var animation_name = "invuln_blink"
	if is_dash:
		animation_name = "dash_blink"
	
	# We don't exist on player layer while invulnerable
	if invuln:
		$AnimationPlayer.play(animation_name)
		# TODO: We should only not collide with bullet
		# not become a ghost
		#set_collision_layer_value(2, false)
	else:
		$AnimationPlayer.stop()
		#set_collision_layer_value(2, true)


func _on_damage_manager_health_updated(health: int, _init_health: int):
	if health <= 0:
		print(health)
		dead = true
		sprite.play("dead")
		died.emit()

func _on_damage_manager_invuln_updated(invuln: bool):
	handle_invuln(invuln, false)


func _on_bridge_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	set_collision_mask_value(7, false)


func _on_bridge_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	set_collision_mask_value(7, true)

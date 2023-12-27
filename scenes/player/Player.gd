class_name Player extends CharacterBody2D

signal health_updated

@export var speed = 125
@export var acceleration = 25
@export var deceleration = 50
@export var top_speed = 150
@export var initial_health = 100
@export var hittable: bool = true
@export var damageable: bool = true
@export var parry_time: float = 1.5
@export var hit_grace: float = 0.1 # time after hit they can still parry
@export var i_time: float = 0.25 # Invincible time after taking damage

const TIME_PER_STEP: float = 0.2

var screen_size = Vector2.ZERO
var initial_modulate: Color
var initial_speed: int


var health: int = initial_health:
	set(v):
		health = v
		health_updated.emit(health)
	
var sprite: AnimatedSprite2D
var taking_damage: bool
var last_parried: Node2D
var parried: bool = false

# TODO: Make this a property of the node that collided
var damage: int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_speed = speed
	
	if $AnimatedSprite2D == null:
		print_debug("no sprite bruh")
		return
			
	sprite = $AnimatedSprite2D
	screen_size = get_viewport_rect().size
	initial_modulate = sprite.modulate
	health = initial_health

func _unhandled_input(_event):
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
		return
	if Input.is_action_just_pressed("parry"):
		parry()
		return

func parry():
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
	
	var light = $Parry/CollisionShape2D/KillLight
	var initial_energy = light.energy
	light.energy = 10
	await get_tree().create_timer(.1).timeout
	light.energy = 0.1
	
	# Animate the parry ring returning to full brightness
	var parry_return_steps = 10
	var time_step = parry_time/parry_return_steps
	var energy_step = initial_energy/parry_return_steps
	for i in parry_return_steps:
		await get_tree().create_timer(time_step).timeout
		light.energy = clamp(light.energy+energy_step, 0, initial_energy)
	parried = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if health <= 0:
		sprite.play("dead")
		return
	handle_movement(delta)

	
func handle_movement(delta: float):
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
		speed = initial_speed
	move_and_collide(velocity * delta)
	
# Called by bullets that detect collision with player
func take_damage(d: int, enemy: Node2D):
	if !hittable || taking_damage:
		return
	if health > 0:
		# Give just a couple frames of leway for them to parry
		await get_tree().create_timer(hit_grace).timeout
		if enemy != last_parried:
			if damageable:
				taking_damage = true
				health -= d
				print(health)
			if hittable:
				sprite.modulate = Color("ff0000")
				get_tree().create_timer(.25).timeout.connect(func():
					sprite.modulate = initial_modulate
				)
			if is_instance_valid(enemy):
				enemy.queue_free()
			await get_tree().create_timer(i_time).timeout
			taking_damage = false
			
	
func blink():
	for i in 10:
		sprite.visible = not sprite.visible
		await get_tree().create_timer(0.25).timeout

func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "dead":
		process_mode = Node.PROCESS_MODE_DISABLED

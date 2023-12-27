class_name Player extends CharacterBody2D

signal health_updated

@export var speed = 100
@export var acceleration = 10
@export var top_speed = 150
@export var steps_to_accel: float = 3
@export var steps_to_decel: float = 2
@export var initial_health = 100
@export var hittable: bool = true
@export var damageable: bool = true
@export var parry_time: float = 1.5
@export var hit_grace: float = 0.1 # time after hit they can still parry
@export var i_time: float = 0.25 # Invincible time after taking damage

const TIME_PER_STEP: float = 0.2

var screen_size = Vector2.ZERO
var initial_modulate: Color
var parryables: Array[Node2D]
var initial_speed: int


var health: int = initial_health:
	set(v):
		health = v
		health_updated.emit(health)
	
var sprite: AnimatedSprite2D
var taking_damage: bool
var bounced: bool = false
var last_parried: Node2D
var parried: bool = false

# TODO: Make this a property of the node that collided
var damage: int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_speed = speed
	
	#$Parry.process_mode = Node.PROCESS_MODE_DISABLED
	if $AnimatedSprite2D == null:
		print_debug("no sprite bruh")
		return
			
	sprite = $AnimatedSprite2D
	screen_size = get_viewport_rect().size
	initial_modulate = sprite.modulate
	health = initial_health
	#setup_shadow()

func _unhandled_input(event):
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
		return
	if Input.is_action_just_pressed("parry"):
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
					
		var initial_energy = $Parry/CollisionShape2D/KillLight.energy
		$Parry/CollisionShape2D/KillLight.energy = 0.1
		
		var parry_return_steps = 10
		var step = parry_time/parry_return_steps
		for i in parry_return_steps:
			await get_tree().create_timer(step).timeout
			$Parry/CollisionShape2D/KillLight.energy += initial_energy/parry_return_steps
		parried = false
		
#func setup_shadow():
#	var frame = $AnimatedSprite2D.get_frame()
#	var animation = $AnimatedSprite2D.get_animation()
#	var texture = $AnimatedSprite2D.get_sprite_frames().get_frame_texture(animation, frame)
#
#	# At least right now, this will always just be the atlas texture
#	# set our shadow's texture
#	if $AnimatedSprite2D/SpriteShadow == null:
#		print_debug("no sprite shadow attached to player")
#		return
#
#	var shadow = $AnimatedSprite2D/SpriteShadow
#	shadow.texture = texture
	
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if health <= 0:
		sprite.play("dead")
		return
	handle_movement(delta)

	
func handle_movement(delta: float):
	if bounced:
		move_and_collide(velocity*delta)
		return
	
	if Input.is_action_pressed("move_right"):
		sprite.flip_h = false
	if Input.is_action_pressed("move_left"):
		sprite.flip_h = true
		
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	
	if speed < top_speed:
		speed += acceleration
	
	sprite.play("walk")

	if velocity.length() == 0:
		sprite.play("idle")
		speed = initial_speed
		
	var collision = move_and_collide(velocity * delta)
	if collision:
		#velocity = velocity.slide(collision.get_normal())
		
		var collider = collision.get_collider()
		if collider.is_in_group("enemy"):
			# bounce with it
			bounced = true
			get_tree().create_timer(.1).timeout.connect(func(): 
					bounced = false
			)
			velocity = velocity.bounce(collision.get_normal())
		else:
			velocity = velocity.slide(collision.get_normal())
	
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

func start():
	sprite.show()
	
func end():
	sprite.hide()

func _on_animated_sprite_2d_animation_finished():
	if sprite.animation == "dead":
		process_mode = Node.PROCESS_MODE_DISABLED

func _on_parry_area_entered(area):
	print("YO")
	parryables.append(area)
		
func _on_parry_area_exited(area):
	parryables.pop_at(parryables.find(area))

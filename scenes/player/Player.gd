class_name Player extends CharacterBody2D

signal health_updated

@export var speed = 500
@export var steps_to_accel: float = 3
@export var steps_to_decel: float = 2
@export var initial_health = 100

const TIME_PER_STEP: float = 0.2

var screen_size = Vector2.ZERO
var initial_modulate: Color


var health: int = initial_health:
	set(v):
		health = v
		health_updated.emit(health)
	
var local_speed: int = 0
var walk_delta: float = 0
var walk_steps: int = 0
var last_velocity: Vector2
var sprite: AnimatedSprite2D
var taking_damage: bool
var bounced: bool = false

# TODO: Make this a property of the node that collided
var damage: int = 10



# Called when the node enters the scene tree for the first time.
func _ready():
	if $AnimatedSprite2D == null:
		print_debug("no sprite bruh")
		return
			
	sprite = $AnimatedSprite2D
	screen_size = get_viewport_rect().size
	initial_modulate = sprite.modulate
	health = initial_health
	#setup_shadow()
	
	
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
	
	if taking_damage && damage != 0:
		health -= damage * delta
	
func handle_movement(delta: float):
	if bounced:
		move_and_collide(velocity*delta)
		return
	
	if Input.is_action_pressed("move_right"):
		if sprite != null:
			sprite.flip_h = false
	if Input.is_action_pressed("move_left"):
		if sprite != null:
			sprite.flip_h = true
		
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction

	#if Input.is_action_just_pressed("move_right") || Input.is_action_just_pressed("move_left"):
		#walk_steps = 0	
	
	# If our intent is to move forward
	if velocity.length() != 0:
		
		# immediately start walking instead of letting an 
		# empty step pass
		if walk_delta == 0:
			walk_steps = 1
			
		# increment steps if enough time has passed
		if walk_delta >= TIME_PER_STEP:
			walk_steps = clamp(walk_steps+1, 0, steps_to_accel)
			walk_delta = 0
			
		# accelerate if we've taken few enough steps
		if walk_steps <= steps_to_accel:
			local_speed = (speed/steps_to_accel) * walk_steps 
		
		if sprite != null:
			sprite.play("walk")
	elif walk_steps > 0:
		# If our velocity is zero but walk_steps > 0 
		# we just stopped moving because we haven't reset
		# walk_steps
		if walk_delta >= TIME_PER_STEP:
			walk_steps = clamp(walk_steps-1, 0, steps_to_decel)
			walk_delta = 0
			
		var decel_amount = speed/steps_to_decel
		local_speed -= decel_amount
		velocity = last_velocity
		
	local_speed = clamp(local_speed, 0, speed)	
	walk_delta += delta
	velocity = velocity.normalized() * local_speed

	if velocity.length() == 0:
		if sprite != null:
			sprite.play("idle")
		#local_speed = 0
		walk_delta = 0
		walk_steps = 0
		
	var collision = move_and_collide(velocity * delta)
	if collision:
		#velocity = velocity.slide(collision.get_normal())
		
		var collider = collision.get_collider()
		if collider.is_in_group("enemy"):
			print("BOUNCE - ", velocity)
			# bounce with it
			bounced = true
			get_tree().create_timer(.1).timeout.connect(func(): 
					bounced = false
			)
			velocity = velocity.bounce(collision.get_normal())
		else:
			velocity = velocity.slide(collision.get_normal())
	#position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)
	last_velocity = velocity
	
# Called by bullets that detect collision with player
func take_damage(d: int):
	if health > 0:
		health -= d
		
	sprite.modulate = Color("ff0000")
	await get_tree().create_timer(.25).timeout
	sprite.modulate = initial_modulate
	
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

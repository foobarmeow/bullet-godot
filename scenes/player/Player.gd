extends Area2D

@export var speed = 500
@export var steps_to_accel: float = 3
@export var steps_to_decel: float = 2
@export var initial_health = 100
@export var exp: bool = false

const TIME_PER_STEP: float = 0.2

var screen_size = Vector2.ZERO
var initial_modulate: Color
var alive: bool = true
var health: int = initial_health
var local_speed: int = 0
var walk_delta: float = 0
var walk_steps: int = 0
var last_velocity: Vector2
var sprite

signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $AnimatedSprite2D
	screen_size = get_viewport_rect().size
	initial_modulate = sprite.modulate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !alive:
		return
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y = -1
	if Input.is_action_pressed("move_down"):
		velocity.y = 1
	if Input.is_action_pressed("move_right"):
		velocity.x = 1
		sprite.flip_h = false
	if Input.is_action_pressed("move_left"):
		velocity.x = -1
		sprite.flip_h = true

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
		sprite.play("idle")
		#local_speed = 0
		walk_delta = 0
		walk_steps = 0
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	last_velocity = velocity
	
func blink():
	for i in 10:
		sprite.visible = not sprite.visible
		await get_tree().create_timer(0.25).timeout

func start():
	alive = true
	sprite.show()
	
func end():
	alive = false
	sprite.hide()

func _on_area_entered(area):
	if exp:
		sprite.modulate = Color("ff0000")
		await get_tree().create_timer(.25).timeout
		sprite.modulate = initial_modulate
		return
	if alive:
		alive = false
		lives -= 1
		hit.emit(lives)
	

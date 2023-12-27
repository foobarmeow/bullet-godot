extends Area2D

@export var speed = 1200
@export var initial_lives = 1

var screen_size = Vector2.ZERO
var alive: bool = true
var lives: int = initial_lives

signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

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
	if Input.is_action_pressed("move_left"):
		velocity.x = -1
		
	if velocity.length() != 0:
		velocity = velocity.normalized() * speed
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func blink():
	for i in 10:
		$Sprite2D.visible = not $Sprite2D.visible
		await get_tree().create_timer(0.25).timeout

func start():
	alive = true
	$Sprite2D.show()
	
func end():
	alive = false
	$Sprite2D.hide()

func _on_area_entered(area):
	if alive:
		alive = false
		lives -= 1
		hit.emit(lives)
	

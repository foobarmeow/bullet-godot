extends Area2D

@export var speed = 1200
@export var initial_lives = 1
@export var exp: bool = false

var screen_size = Vector2.ZERO
var initial_modulate: Color
var alive: bool = true
var lives: int = initial_lives

signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	initial_modulate = $Sprite2D.modulate

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
	if exp:
		$Sprite2D.modulate = Color("ff0000")
		await get_tree().create_timer(.25).timeout
		$Sprite2D.modulate = initial_modulate
		return
	if alive:
		alive = false
		lives -= 1
		hit.emit(lives)
	

extends Node2D

@export var speed: int = 100
@export var offset_from_player: int = 25

const PROGRAM_RANDOM = "random"

var program: String
var player: Node2D
var dir: Vector2

func _ready():
	print("mover ready")
	start(PROGRAM_RANDOM, get_node("../Player"))

func start(prgm: String, p):
	program = prgm
	player = p
	
	if player == null:
		return
	
	dir = position - get_random_position()

func _process(delta):
	return
	var v = dir * speed
	translate(v.rotated(rotation) * delta)
	
func get_random_position(offset: int = 0):
	if player == null:
		return
	# Find our center point, randomly
	var viewport = get_viewport_rect().size
	var center = Vector2(
		randi_range(0+offset, viewport.x-offset), 
		randi_range(0+offset, viewport.y-offset), 
	)
	
	var diff = player.global_position - center
	if diff.length() < offset_from_player:
		# This was inside our threshold, try again
		# lower the threshold to be safe
		if offset_from_player > 0:
			offset_from_player -= 2
		return get_random_position(offset)
	return center
	

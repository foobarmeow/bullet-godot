extends PathFollow2D

enum MovementType {RANDOM, PATHED = -1}

@export var speed: float = .01
@export var offset_from_player: int = 25
@export var movement_type: MovementType

var dir: Vector2
var target: Vector2
var _player

func _ready():
	var player = get_node("../Player")
	if player == null:
		return
	_player = player
	if movement_type == MovementType.RANDOM:
		target = get_random_position(player)


func _process(delta):
	$AnimatedSprite2D.play()
	match movement_type:
		MovementType.RANDOM:
			var diff = position - target
			# some threshold here would be good
			if diff.length() < 20:
				target = get_random_position(_player)
				return
			position = position.move_toward(target, delta*speed)
		MovementType.PATHED:
			var i = speed * delta
			progress_ratio += i
			
func get_random_position(player, offset: int = 0):
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
	

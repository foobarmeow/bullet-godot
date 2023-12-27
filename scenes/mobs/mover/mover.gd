extends PathFollow2D

signal burst

enum MovementType {STOPPED, RANDOM, PATHED = -1}

@export var speed: float = .01
@export var offset_from_player: int = 25
@export var movement_type: MovementType

var fill: float = 0
var filling: float = 0

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

	if filling > 0:
		fill += filling * delta
	elif fill > 0:
		fill -= .5 * delta

	if fill >= 1:
		burst.emit(self)
		queue_free()
	elif fill > .90:
		shake(delta, 8)
	elif fill > 0.75:
		shake(delta, 5)
	elif fill > 0.50:
		shake(delta, 3)
	elif fill > 0.25:
		shake(delta, 1)
	elif fill > 0:
		shake(delta, .25)
		
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
		MovementType.STOPPED:
			return
			
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
	

var outside_fill = .25
var inside_fill = .45


func _on_outside_radius_area_entered(area):
	filling = outside_fill
func _on_inside_radius_area_entered(area):
	filling = inside_fill
func _on_inside_radius_area_exited(area):
	filling = outside_fill
func _on_outside_radius_area_exited(area):
	filling = 0

func shake(delta, factor):
	var p = Vector2.from_angle(randf_range(0, TAU)) * delta
	$AnimatedSprite2D.position = p.normalized() * factor
	
	


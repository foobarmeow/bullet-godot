extends Node2D

@export var bullet: PackedScene
@export var speed: int = 900

const SPAWNER_LEFT = "left"
const SPAWNER_PLUS = "plus"
const SPAWNER_CIRCLE = "circle"

#var type: String = SPAWNER_LEFT
var type: String = SPAWNER_CIRCLE

func _ready():
	$FireTimer.timeout.connect(fire)

func fire():
	print("here", bullet, type)
	if bullet == null:
		return

	match type:
		SPAWNER_LEFT:
			var v = Vector2.LEFT * speed
			add_bullet(v)
		SPAWNER_PLUS:
			for v in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
				add_bullet(v*speed)
		SPAWNER_CIRCLE:
			var steps = 8
			var angle = 0.0
			var step = TAU/steps
			for i in steps:
				var v = Vector2.UP.rotated(angle) * speed
				add_bullet(v)
				angle += step

func add_bullet(v):
	var b = bullet.instantiate()
	get_tree().root.add_child(b)
	b.position = global_position
	#add_child(b)
	b.fire(v)
				
				
			
			

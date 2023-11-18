extends Node2D

@export var type: Constants.SpawnerType
@export var bullet: PackedScene
@export var speed: int = 900

func _ready():
	$FireTimer.timeout.connect(fire)

func fire():
	if bullet == null:
		return

	match type:
		Constants.SpawnerType.LEFT:
			var v = Vector2.LEFT * speed
			add_bullet(v)
		Constants.SpawnerType.PLUS:
			for v in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
				add_bullet(v*speed)
		Constants.SpawnerType.CIRCLE:
			var steps = 8
			var angle = 0.0
			var step = TAU/steps
			for i in steps:
				var v = Vector2.UP.rotated(angle) * speed
				add_bullet(v)
				angle += step

func add_bullet(v):
	var b = bullet.instantiate()
	b.position = global_position
	get_tree().root.add_child(b)
	
	#add_child(b)
	b.fire(v)
				
				
			
			

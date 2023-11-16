extends Node2D

@export var mob_scene: PackedScene

func start(type: String):
	match type:
		"circle":
			spawn_circle(1)
			

func spawn_circle(n: int):
	
	# Find our center point, randomly
	var viewport = get_viewport_rect().size
	var center = Vector2(
		randi_range(0, viewport.x), 
		randi_range(0, viewport.y), 
	)
		
	for i in n:
		var pos = center
		pos.x += 10
		
		var mob = mob_scene.instantiate()
		mob.position = pos
		mob.visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

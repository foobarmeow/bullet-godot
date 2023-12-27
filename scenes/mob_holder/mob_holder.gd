extends Node2D

@export var mob_scene: PackedScene

var player: Area2D

func start(type: String, p: Area2D):
	player = p
	match type:
		"circle":
			spawn_circle(1)
					

func spawn_circle(n: int):
	var mobForOffset = mob_scene.instantiate()
	var offset = mobForOffset.get_node("Sprite2D").texture.get_width()
	
	mobForOffset.queue_free()
	
	# Find our center point, randomly
	var viewport = get_viewport_rect().size
	var center = Vector2(
		randi_range(0+offset, viewport.x-offset), 
		randi_range(0+offset, viewport.y-offset), 
	)
	position = center

	
	# override n = 4 for now
	n = 4
	for i in n:
		var mob = mob_scene.instantiate()
		add_child(mob)
		match i:
			0:
				mob.position = Vector2(offset, offset)
			1:
				mob.position = Vector2(-offset, offset)
			2:
				mob.position = Vector2(-offset,  -offset)
			3: 
				mob.position = Vector2(offset, -offset)
			
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		look_at(player.position)

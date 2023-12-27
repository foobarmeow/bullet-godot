extends Node2D

@export var mob_scene: PackedScene
@export var tracking_timeout: float = 0.5
@export var speed: int = 400
@export var offset_from_player: int = 100

var player: Area2D
var tracking: bool

func start_random(p: Area2D):
	var types = ["square", "line"]
	start(types[randi_range(0, 1)], p)

func start(type: String, p: Area2D):
	player = p
	tracking = true
	match type:
		"square":
			spawn_square(1)
		"line":
			spawn_line()
			
func spawn_line():
	var mobForOffset = mob_scene.instantiate()
	var offset = mobForOffset.get_node("Sprite2D").texture.get_width()
	mobForOffset.queue_free()
	
	offset += 15
	
	position = get_spawn_position(offset)
	
	var n = 5
	var start = -(offset * n/2)
	for i in n:
		var mob = mob_scene.instantiate()
		add_child(mob)
		mob.position = Vector2(0, start)
		start += offset
				
	# After the timeout, stop tracking
	await get_tree().create_timer(tracking_timeout).timeout
	tracking = false
	
					

func spawn_square(n: int):
	var mobForOffset = mob_scene.instantiate()
	var offset = mobForOffset.get_node("Sprite2D").texture.get_width()
	mobForOffset.queue_free()
	
	position = get_spawn_position(offset)
		
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
				
	# After the timeout, stop tracking
	await get_tree().create_timer(tracking_timeout).timeout
	tracking = false
			
func get_spawn_position(offset: int):
	if player == null:
		return
	
	# Find our center point, randomly
	var viewport = get_viewport_rect().size
	var center = Vector2(
		randi_range(0+offset, viewport.x-offset), 
		randi_range(0+offset, viewport.y-offset), 
	)
	
	print(center)
	
	var diff = player.global_position - center
	if diff.length() < offset_from_player:
		# This was inside our threshold, try again
		print_debug("too close to player, trying again: ", offset_from_player)
		# lower the threshold to be safe
		if offset_from_player > 0:
			offset_from_player -= 10
		return get_spawn_position(offset)
	return center
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null && tracking:
		look_at(player.position)
	elif tracking == false:
		translate(Vector2(speed, 0).rotated(rotation) * delta)
		
func _exited_screen():
	queue_free()

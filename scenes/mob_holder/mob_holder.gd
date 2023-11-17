extends Node2D

@export var mob_scene: PackedScene
@export var mob_square: PackedScene
@export var mob_line: PackedScene
@export var tracking_timeout: float = 0.5
@export var speed: int = 400
@export var offset_from_player: int = 250

var player: Area2D
var tracking: bool
var mob_offset: int

func _init():
	if mob_scene != null:
		var mob_for_offset = mob_scene.instantiate()
		mob_offset = mob_for_offset.get_node("Sprite2D").texture.get_width()
		mob_for_offset.queue_free()

func start(type: String, p: Area2D):
	player = p
	match type:
		"square":
			spawn(mob_square)
		"line":
			spawn(mob_line)
			
func spawn(scene: PackedScene):
	position = get_spawn_position(mob_offset)
	var mob = scene.instantiate()
	add_child(mob)
	
	tracking = true
	# After the timeout, stop tracking
	await get_tree().create_timer(tracking_timeout).timeout
	tracking = false
	
func spawn_line_drawn():
	var offset = mob_offset + 15
	position = get_spawn_position(offset)
	
	var n = 30
	var start_offset = -(offset * n/2)
	for i in n:
		var mob = mob_scene.instantiate()
		add_child(mob)
		mob.position = Vector2(0, start_offset)
		start_offset += offset
				
	# After the timeout, stop tracking
	await get_tree().create_timer(tracking_timeout).timeout
	tracking = false

func spawn_square_drawn():
	var offset = mob_offset
	position = get_spawn_position(offset)
	for i in 4:
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
		
	var diff = player.global_position - center
	if diff.length() < offset_from_player:
		# This was inside our threshold, try again
		# lower the threshold to be safe
		if offset_from_player > 0:
			offset_from_player -= 10
		return get_spawn_position(offset)
	return center

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null && tracking:
		look_at(player.position)
	elif tracking == false:
		translate(Vector2(speed, 0).rotated(rotation) * delta)
		
func _exited_screen():
	queue_free()

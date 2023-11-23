@tool
extends Line2D

@export var point_texture: Texture
@export var sprite_light: PackedScene
@export var do = false:
	set(value):
		draw_items(value)
		do = value
	get: 
		return do

func _ready():
	draw_items(true)

# Called when the node enters the scene tree for the first time.
func draw_items(draw: bool):
	for c in $Spawn.get_children():
		c.queue_free()
		
	if !draw:
		return
	var last_point
	for p in points:
		if last_point == null:
			last_point = p
			continue
			
		var segment = p - last_point
		var points_in_segment = floor(segment.length() / point_texture.get_width())
		print(points_in_segment)
		for i in points_in_segment:
			var t: float
			if points_in_segment == 1:
				t = 1
			else:
				t = i / (points_in_segment - 1)
			print(t)
			var np = last_point.lerp(p, t)
			print(np)
			set_at(np, segment.angle())
			
		last_point = p
		
func set_at(p: Vector2, angle: float):
	var l = sprite_light.instantiate()
	l.texture = point_texture
	l.position = p
	l.rotation = angle
	$Spawn.add_child(l)
	l.set_owner(get_tree().get_edited_scene_root())

@tool
extends Line2D

@export var point_texture: Texture
@export var do = false:
	set(value):
		draw_items()
		do = value
	get: 
		return do

func _ready():
	draw_items()

# Called when the node enters the scene tree for the first time.
func draw_items():
	for c in $Spawn.get_children():
		c.queue_free()
		
	var last_point
	for p in points:
		if last_point == null:
			last_point = p
			continue
			
		var segment = p - last_point
		var points_in_segment = floor(segment.length() / point_texture.get_width())
		
		for i in points_in_segment:
			var t = i / (points_in_segment - 1)
			print("t", t)
			var np = last_point.lerp(p, t)
					
			var s = Sprite2D.new()
			s.texture = point_texture
			s.position = np
			
			$Spawn.add_child(s)
			s.set_owner(get_tree().get_edited_scene_root())
			
		
		last_point = p
		
		
	

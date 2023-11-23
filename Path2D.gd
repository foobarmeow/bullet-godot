@tool
extends Line2D

@export var thing_to_draw: Texture
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
			
		var t = Sprite2D.new()
		t.texture = thing_to_draw
		t.position = p
		
		var d = p.distance_to(last_point)
		print(d)
		
		var y_diff = p.y - last_point.y
		print("y diff ", y_diff)
		
		var pos: Vector2
		if y_diff > 0:
			t.rotate(TAU/4)
			pos = Vector2(p.x, p.y - last_point.y)
		else:
			pos = Vector2(p.x - last_point.x, p.y)
			
			
		#t.scale.x = d/100
		t.position = p
		
		
		last_point = p
		
		
		$Spawn.add_child(t)
		t.set_owner(get_tree().get_edited_scene_root())

@tool
extends RigidBody2D

@export var shield_size_degrees: int = 5
@export var track_mouse: bool = false

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.


func parry():
	var v = Vector2.RIGHT.rotated(rotation) * 100
	print(v)
	add_constant_force(v, Vector2.ZERO)
	

func _process(delta):
	if !track_mouse:
		return
		
	var mouse_position = get_global_mouse_position()
	var angle_to_mouse = atan2(mouse_position.y - to_global(position).y, mouse_position.x - to_global(position).x)
	rotation = angle_to_mouse
	



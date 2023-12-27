@tool
extends RigidBody2D

@export var shield_size_degrees: int = 5
@export var track_mouse: bool = false

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.


var parrying = false
func parry():
	if parrying:
		return
	set_collision_layer_value(8, true)
	parrying = true
	await get_tree().create_timer(.25).timeout
	parrying = false
	set_collision_layer_value(8, false)
	

func _physics_process(delta):
	if !track_mouse:
		return
		
	look_at(get_global_mouse_position())
		
#
#	var mouse_position = get_global_mouse_position()
#	var angle_to_mouse = atan2(mouse_position.y - to_global(position).y, mouse_position.x - to_global(position).x)
#	rotation = angle_to_mouse
	

	



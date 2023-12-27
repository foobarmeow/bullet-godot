@tool
extends Sprite2D

@export var shield_size_degrees: int = 5
@export var track_mouse: bool = false

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

func check_position(pos: Vector2, width: int):
	var a = is_in_shield_angle(pos)
	var w = is_in_shield_width(pos, width)
	# I'm too fucking stupid to get this `in shield width` thing 
	# to work, so come back to this and fix it FUCK
	return a

func is_in_shield_width(pos: Vector2, width: int):
	var cr = material.get_shader_parameter("circle_radius")
	var sw = material.get_shader_parameter("segment_width")
	
	var circle_radius = cr * min(1024, 768)
	var segment_width = sw * min(1024, 768)

	
	
	var distance_to_center = to_local(pos).distance_to(position)
	print("%s - %s - %s - %s - %s - %s" % [distance_to_center, circle_radius, segment_width, width, to_local(pos), position])
	if (distance_to_center >= circle_radius - 0.5 * segment_width) && (distance_to_center <= circle_radius + 0.5 * segment_width):
		return true
	return false

func is_in_shield_angle(pos: Vector2):
	var angles = get_shield_angles()
	var angle_to_pos_rad = atan2(pos.y - to_global(position).y, pos.x - to_global(position).x)
	var angle_to_pos_deg = fmod(rad_to_deg(angle_to_pos_rad)+360.0, 360.0)
	if angles.x <= angle_to_pos_deg && angles.y >= angle_to_pos_deg:
		return true
	return false

func get_shield_angles() -> Vector2:
	var mouse_position = get_global_mouse_position()
	
	var angle_midpoint = atan2(mouse_position.y - to_global(position).y, mouse_position.x - to_global(position).x)
	var angle_midpoint_deg = rad_to_deg(angle_midpoint)
	
	# Ensure angle is in the range [0, 360)
	angle_midpoint_deg = fmod(angle_midpoint_deg + 360.0, 360.0)

	var start = angle_midpoint_deg - shield_size_degrees
	var end = angle_midpoint_deg + shield_size_degrees
	return Vector2(start, end)
	

func _process(delta):
	if !track_mouse:
		return
	
	var shield_angles = get_shield_angles()
	material.set_shader_parameter("start_angle", shield_angles.x)
	material.set_shader_parameter("end_angle", shield_angles.y)


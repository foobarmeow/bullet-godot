@tool
extends Sprite2D

@export var shield_size_degrees: int = 5
@export var track_mouse: bool = false

var collision_polygon: CollisionPolygon2D


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
	# Update the vertices of the CollisionPolygon2D based on shader parameters
	update_collision_polygon(shield_angles)
	

	material.set_shader_parameter("start_angle", shield_angles.x)
	material.set_shader_parameter("end_angle", shield_angles.y)


func update_collision_polygon(angles: Vector2):
	# Calculate the vertices of the CollisionPolygon2D based on the shader parameters
	var vertices = PackedVector2Array()
	var num_segments = 100  # Adjust as needed for smoothness

	var circle_radius = 1000
	var segment_width = 0.5
	
	for i in range(num_segments + 1):
		var angle = lerp_angle(deg_to_rad(angles.x), deg_to_rad(angles.y), i / float(num_segments))
		
		# Calculate inner and outer points based on segment width
		var inner_x = 0.5 + (circle_radius - 0.5 * segment_width) * cos((angle))
		var inner_y = 0.5 + (circle_radius - 0.5 * segment_width) * sin((angle))

		var outer_x = 0.5 + (circle_radius + 0.5 * segment_width) * cos((angle))
		var outer_y = 0.5 + (circle_radius + 0.5 * segment_width) * sin((angle))

		# Add both inner and outer points to form a segment
		vertices.append(Vector2(inner_x, inner_y))
		vertices.append(Vector2(outer_x, outer_y))

	# Set the vertices of the CollisionPolygon2D
	#collision_polygon.polygon = vertices
	$Area2D/CollisionPolygon2D.polygon = vertices

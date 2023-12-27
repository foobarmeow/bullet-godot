class_name Util

static func get_random_position(
	bounds: Vector2, 
	avoid: Node2D, 
	offset: int = 0,
	offset_from_avoid: int = 0,
):
	# Find our a point, randomly
	var pos = Vector2(
		randi_range(0+offset, bounds.x-offset), 
		randi_range(0+offset, bounds.y-offset), 
	)
	
	if avoid != null:
		var diff = avoid.global_position - pos
		if diff.length() < offset_from_avoid:
			# This was inside our threshold, try again
			# lower the threshold to be safe
			if offset_from_avoid > 0:
				offset_from_avoid -= 2
			return get_random_position(bounds, avoid, offset, offset_from_avoid)
	return pos
extends RigidBody2D

@onready var chunk: Sprite2D = $RockParticle

func _on_body_entered(body):
	if body.is_in_group("walls"):
		throw_chunks()
		queue_free()

func throw_chunks():
	for i in 5:
		var s = Sprite2D.new()
		s.texture = chunk.texture
		s.rotation = rad_to_deg(randf_range(0, 1))
		s.scale = chunk.scale
		get_tree().root.add_child(s)
		s.position = global_position
		s.position.x += randf_range(-10, 10)
		s.position.y += randf_range(-10, 10)


func set_particles(target: Vector2):
	var pm = $Particles.process_material
	pm.direction = Vector3(target.x, target.y, 0)

	$Particles.emitting = true

extends RigidBody2D

func _on_body_entered(body):
	if body.is_in_group("walls"):
		queue_free()


func set_particles(target: Vector2):
	var pm = $Particles.process_material
	pm.direction = Vector3(target.x, target.y, 0)

	$Particles.emitting = true

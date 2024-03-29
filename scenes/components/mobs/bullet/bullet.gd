extends CharacterBody2D

var speed: int
var fired: bool
var fired_at: int
var from: Vector2
var parry_speed: int
var armed: bool = false
var parried: bool = false

func get_width():
	return $Sprite2D.texture.get_width()

func fire():
	fired_at = Engine.get_frames_drawn()
	fired = true

func parry(random: bool):
	if random:
		velocity = position.rotated(randf_range(0, 1) * speed/2)
		return
	# We want to collide with enemies now
	set_collision_mask_value(3, true)
	modulate = Color(0.0, 106.0, 252.0, 255)
	velocity = position.direction_to(from) * (parry_speed)
	parried = true
	
func destroy():
	# TODO: some particle or something
	queue_free()

func _physics_process(delta):
	if !fired:
		return
	rotation += TAU / 16
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		var collider = collision.get_collider()
		if collider.has_method("take_damage"):
			if armed:
				collider.take_damage(10, self)
			return
		elif collider.is_in_group("shield"):
			velocity = velocity.bounce(collision.get_normal())*5
			set_collision_mask_value(3, true)
			modulate = Color(0.0, 106.0, 252.0, 255)
			return
		elif Engine.get_frames_drawn() - fired_at < 10:
			# It's nice to have them dissapear when they
			# hit another enemy, but we have to add this lag
			# so that they have time to get away from their origin
			return
		queue_free()


func _on_screen_exit():
	queue_free()


func _on_area_2d_area_exited(area):
	if area.name == "FromBox":
		armed = true

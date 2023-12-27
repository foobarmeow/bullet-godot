extends CharacterBody2D

var speed: int
var fired: bool
var fired_at: int
var from: Vector2
var parry_speed: int
var armed: bool = false

func fire():
	fired_at = Engine.get_frames_drawn()
	fired = true

func parry():
	# We want to collide with enemies now
	set_collision_mask_value(3, true)
	velocity = position.direction_to(from) * (parry_speed)
	
func destroy():
	# TODO: some particle or something
	queue_free()

func _physics_process(delta):
	if !fired:
		return
	rotation += TAU / 16
	var collision = move_and_collide(velocity * delta)
	
	# Since (FOR NOW) the bullet only collides with walls
	# we can assume that non null collisions mean it should 
	# remove itself

	
	if collision != null:
		var collider = collision.get_collider()
		if collider is Player:
			# Pass a reference to myself so it knows who brought the heat
			if armed:
				collider.take_damage(10, self)
			return # We'll let the damage taker free it
		elif collider is Mover:
			if armed:
				collider.destroy()
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

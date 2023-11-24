extends CharacterBody2D

var speed: int
var fired: bool
var fired_at: int

func fire():
	fired_at = Engine.get_frames_drawn()
	fired = true


func _process(delta):
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
			collider.take_damage(10)
		elif collider is StaticBody2D:
			# If we ran into a static body we want to bounce off of it
			velocity = velocity.bounce(collision.get_normal())
			return
		elif Engine.get_frames_drawn() - fired_at < 10:
			# It's nice to have them dissapear when they
			# hit another enemy, but we have to add this lag
			# so that they have time to get away from their origin
			return
		queue_free()


func _on_screen_exit():
	queue_free()

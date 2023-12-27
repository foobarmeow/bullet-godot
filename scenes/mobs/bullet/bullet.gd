extends CharacterBody2D

var speed: int
var fired: bool
var fired_at: int
var from: Vector2
var parry_speed: int

func fire():
	fired_at = Engine.get_frames_drawn()
	fired = true


func _process(delta):
	if !fired:
		return
	#rotation += TAU / 16
	var collision = move_and_collide(velocity * delta)
	
	# Since (FOR NOW) the bullet only collides with walls
	# we can assume that non null collisions mean it should 
	# remove itself

	
	if collision != null:
		print(collision.get_collider())
		var collider = collision.get_collider()
		if collider is Player:
			collider.take_damage(10)
		elif collider is Mover:
			print("ya dead!")
		elif collider is StaticBody2D:
			# If we ran into a static body we want to bounce off of it
						#velocity = velocity.bounce(collision.get_normal())
			# Either bounce or go back to the originator
			
			# We're no longer a bullet
			set_collision_mask_value(3, true)
			# We're a magic
			
			print(delta*parry_speed)
			# TODO: sometimes this can end up with the bullet getting a little stuck 
			# on the parry collider
			velocity = position.direction_to(from) * (parry_speed)
			#collision = move_and_collide(velocity)
			#if collision != null && collision.get_collider() is Mover:
			#	#collision.get_collider().queue_free()
			#	print("ya dead!")
			
			return
		elif Engine.get_frames_drawn() - fired_at < 10:
			# It's nice to have them dissapear when they
			# hit another enemy, but we have to add this lag
			# so that they have time to get away from their origin
			return
		queue_free()


func _on_screen_exit():
	queue_free()

extends CharacterBody2D

var speed: int
var fired: bool


func fire():
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
		queue_free()


func _on_screen_exit():
	queue_free()

extends Area2D

var velocity: Vector2
var speed: int
var fired: bool

func fire(v: Vector2):
	velocity = v
	fired = true


func _process(delta):
	if !fired:
		return
	translate(velocity.rotated(rotation) * delta)


func _on_screen_exit():
	return
	queue_free()

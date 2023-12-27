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
	var v = velocity.rotated(rotation)
	translate(v * delta)


func _on_screen_exit():
	queue_free()

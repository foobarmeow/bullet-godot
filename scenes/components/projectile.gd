extends Node2D

var target: Vector2
var hit_threshold: int = 5
var speed: int = 900


func _physics_process(delta):
	if target:
		look_at(target)
		position = position.move_toward(target, delta*speed)
		
		if position.distance_to(target) < hit_threshold:
			queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

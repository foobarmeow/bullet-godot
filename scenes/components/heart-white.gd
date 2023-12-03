extends Node2D

func remove():
	$HeartSprite/AnimationPlayer.play("loss")


func _on_animation_player_animation_finished(_anim_name):
	queue_free()

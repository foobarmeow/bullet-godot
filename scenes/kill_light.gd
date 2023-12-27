extends Node2D

signal parry_recharged


func activate():
	$AnimationPlayer.play("parry_activate")

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"parry_activate":
			$AnimationPlayer.play("parry_recharge")
		"parry_recharge":
			parry_recharged.emit()

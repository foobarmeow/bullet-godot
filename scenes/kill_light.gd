@tool
extends Node2D

signal parry_recharge

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	#$AnimationPlayer.play("idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_player_parry(p: Player):
	$AnimationPlayer.play("parry_activate")
	player = player


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"parry_activate":
			$AnimationPlayer.play("parry_recharge")
		"parry_recharge":
			player.parried = false

@tool
extends PointLight2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#$AnimationPlayer.play("idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_player_perry():
	$AnimationPlayer.play("parry")

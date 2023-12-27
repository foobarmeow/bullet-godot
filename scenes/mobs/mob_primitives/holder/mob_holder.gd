extends Node2D

signal exit
signal entered

@export var player: Area2D
@export var tracking: bool = false
@export var speed: int = 400

func _process(delta):
	if player != null && tracking:
		look_at(player.position)
	elif tracking == false && player != null:
		translate(Vector2(speed, 0).rotated(rotation) * delta)
		
func _on_exit_screen():
	exit.emit()


func _on_area_entered(area):
	entered.emit(tracking)
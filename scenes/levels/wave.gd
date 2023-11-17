extends Node2D

var player: Area2D

func start(p: Area2D):
	player = p
	for c in get_children():
		c.player = p
		c.tracking = true
	await get_tree().create_timer(1.5).timeout
	for c in get_children():
		c.tracking = false
	
	
	

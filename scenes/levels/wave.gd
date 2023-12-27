extends Node2D

signal wave_complete

@export var track_timeout: float = 1.5

var player: Area2D
var mob_count: int = INF

func start(p: Area2D):
	player = p
	
	show()
	var children = get_children()
	mob_count = len(children)
	
	for c in get_children():
		c.exit.connect(_on_mob_exit)
				
		c.player = p
		c.tracking = true
	await get_tree().create_timer(track_timeout).timeout
	for c in get_children():
		c.tracking = false
	
	
func _on_mob_exit():
	print("mob exited")
	mob_count -= 1

func _process(delta):
	if mob_count == 0:
		print("done")
		wave_complete.emit()
		print("emitted wave complete")
		queue_free()
	
	

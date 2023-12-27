extends Node2D

signal level_complete

func start(p: Area2D):
	for wave in get_children():
		wave.start(p)
		print("wave startes")
		await wave.wave_complete
		print("wave done")
	level_complete.emit()

extends Node2D

signal level_complete

var player: Area2D
var hud: CanvasLayer

func start(p: Area2D, h: CanvasLayer):
	player = p
	hud = h

	p.hit.connect(_on_player_hit)
	
	for wave in get_children():
		if !wave.name.to_lower().begins_with("wave"):
			continue
		if player.lives == 0:
			break
		
		wave.player_restart.connect(_on_player_restart)
		wave.start(p)
		await wave.wave_complete
	
	print("level complete", player.lives)
	level_complete.emit(player.lives > 0)
	
func _on_player_hit(lives: int):
	hud.hit(lives)
		
func _on_player_restart():
	player.position = $PlayerSpawnPosition.position
	player.start()


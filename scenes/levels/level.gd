extends Node2D

signal level_complete

@export var level_name: String

var player: Area2D
var hud: CanvasLayer


# so if we run the scene alone, we can
func _ready():
	for wave in get_children():
		if wave.name.to_lower() == "player":
			player = wave
			
	if player != null:
		_on_player_restart()
		start(player, null)
	

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
	if hud != null:
		hud.hit(lives)
		
func _on_player_restart():
	player.position = $PlayerSpawnPosition.position
	player.start()


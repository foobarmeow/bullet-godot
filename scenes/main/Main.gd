extends Node2D

@export var levels: Array


func end_game():
	$Player.end()
	$HUD.end_game()

func _on_hud_start_game():
	$Player.lives = $Player.initial_lives
	var l1 = levels[0].instantiate()
	l1.level_complete.connect(_on_level_complete)
	add_child(l1)
	
	l1.start($Player, $HUD)
	$HUD.hit($Player.lives)
	
func _on_level_complete(alive: bool):
	if !alive:
		end_game()
	else:
		$HUD.level_complete()

func _on_hud_player_ready():
	$Player.start()

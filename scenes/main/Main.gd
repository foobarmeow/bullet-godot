extends Node2D

@export var levels: Array

var current_level
var level_index: int = 0

func game_over():
	$Player.end()
	$HUD.game_over()
	
func end_game():
	$Player.end()
	$HUD.end_game()
	
func _on_hud_start_game():
	current_level.start($Player, $HUD)
	$HUD.hit($Player.lives)
	
func _on_level_complete(alive: bool):
	if !alive:
		game_over()
	elif level_index+1 == len(levels):
		end_game()
	else:
		await $HUD.level_complete()
		
		var old_level = current_level
		level_index += 1
		current_level = levels[level_index].instantiate()
		current_level.level_complete.connect(_on_level_complete)
		
		add_child(current_level)
		#current_level._on_player_restart()
		$HUD.level_start(level_index+1, current_level.level_name)
		
		old_level.queue_free()

func _on_hud_player_ready():
	$Player.lives = $Player.initial_lives
	current_level = levels[0].instantiate()
	current_level.level_complete.connect(_on_level_complete)
	add_child(current_level)
	
	$Player.start()
	$HUD.level_start(1, current_level.level_name)

	

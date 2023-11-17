extends Node2D

@export var mob_holder_scene: PackedScene
@export var lives: int = 3
@export var levels: Array

var _lives = lives

func _on_spawn_timer_timeout():
	spawn()
		
func spawn():
	var types = [
		"square", 
		"line",
	]
	
	var n_per_type = {
		"square": 8,
		"line": 2
	}
	
	var t = types[randi_range(0, 1)]
	for i in n_per_type[t]:
		var mob_holder = mob_holder_scene.instantiate()
		add_child(mob_holder)
		mob_holder.start(t, $Player)

func _on_player_hit():
	get_tree().call_group("mob", "queue_free")
	$SpawnTimer.stop()
	await $Player.blink()
	$Player.position = $PlayerSpawnPosition.position
	$Player.start()
	
	
	_lives -= 1
	if _lives > 0:
		$HUD.hit(_lives)
		
		#spawn()
		#$SpawnTimer.start()
	else:
		end_game()

func end_game():
	$Player.end()
	$HUD.end_game()
	_lives = lives
	$SpawnTimer.stop()


func _on_hud_start_game():
	var l1 = levels[0].instantiate()
	add_child(l1)
	
	var wave1 = l1.get_node("Wave1")
	wave1.start($Player)
	return
	
	spawn()
	$SpawnTimer.start()
	$HUD.hit(_lives)


func _on_hud_player_ready():
	$Player.start()

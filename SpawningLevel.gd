extends Node2D

signal level_complete

func _ready():
	# Expect a child node called MobContainer
	# therein will be this level's enemies in order of spawn?
	
	# But we might want to spawn multiple enemies
	# So perhaps it's a tree of containers 
	var root_container = $MobContainer
	var player = $Player
	
	# Spawn any enemies
	for child in root_container.get_children():
		if child.name == "MobContainer":	
			continue
		# We assume any non MobContainers are mobs
		# Have it do its thing
		child.begin(player)
		
		# Wait until it dies
		await child.burst
		
	level_complete.emit()

	


func _on_player_health_updated(health: int):
	# TODO: Dispatch update to UI
	if health <= 0:
		print("GAME OVER MOTHERFUCKER")

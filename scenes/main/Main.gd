extends Node2D

@export var mob_holder_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _unhandled_input(event):
	if Input.is_action_just_released("spawn"):
		var mob_holder = mob_holder_scene.instantiate()
		add_child(mob_holder)
		mob_holder.start("line", $Player)
		


func _on_spawn_timer_timeout():
	var mob_holder = mob_holder_scene.instantiate()
	add_child(mob_holder)
	mob_holder.start_random($Player)


func _on_player_hit():
	$Player.position = $PlayerSpawnPosition.position

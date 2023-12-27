extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_damage_manager_health_updated(health: int, init_health: int):
	if !$HeartContainer:
		print("not container wtf")
		return
	var heart = $HeartContainer.get_children().pop_back()
	heart.remove()
		


func _on_well_area_area_entered(area):
	# Show drink....stuff
	if done_drinking:
		return
	$AnimationPlayer.play("drink_visibility")

func _on_well_area_area_exited(area):
	if done_drinking:
		return
	$AnimationPlayer.play_backwards("drink_visibility")
	$AnimationPlayer.queue("RESET")

func _on_player_drink():
	if done_drinking:
		return
	$AnimationPlayer.queue("shake_the_drink_text")

var done_drinking: bool = false
func _on_map_level_done_drinking():
	if done_drinking:
		return
	done_drinking = true
	
	$AnimationPlayer.queue("drink_visibility")
	$AnimationPlayer.queue("drank_visibility")
	$AnimationPlayer.queue("return_visibiilty")

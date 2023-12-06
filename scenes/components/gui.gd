extends Control


func _on_damage_manager_health_updated(_health: int, _init_health: int):
	if !$HeartContainer:
		print("not container wtf")
		return
	var heart = $HeartContainer.get_children().pop_back()
	heart.remove()
		

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
	$DrinkSprite.show()

func _on_well_area_area_exited(area):
	$DrinkSprite.hide()

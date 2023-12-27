extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for c in get_children():
		if c.name == "Mover":
			c.begin($Player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

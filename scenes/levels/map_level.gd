extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	for c in get_children():
		if c is Mover:
			c.player = $Player
			c.begin()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

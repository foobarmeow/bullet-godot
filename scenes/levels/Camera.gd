extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("zoom_in"):
		zoom.x += .2
		zoom.y += .2
		print(zoom)
	if Input.is_action_just_pressed("zoom_out"):
		zoom.x -= .2
		zoom.y -= .2
		print(zoom)

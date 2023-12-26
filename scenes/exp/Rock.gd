@tool
extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(linear_velocity.length())
	pass


func _unhandled_input(event):
	if event is InputEventMouseButton && event.pressed:
		apply_torque_impulse(200)
		apply_impulse(to_local(event.position)*100)
		print(to_local(event.position))
		print("Mouse Click/Unclick at: ", event.position)


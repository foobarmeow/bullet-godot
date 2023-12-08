extends Node2D

@export var rockScene: PackedScene
@export var speed: int = 100
@export var torque: float = 200

@onready var ray: RayCast2D = $RayCast2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton && event.pressed:
		print("HERE")
		_on_rock_spawn()

func _on_rock_spawn():
	var r = rockScene.instantiate()
	owner.add_child(r)

	print(ray.target_position)
	r.apply_impulse(ray.target_position*1)
	r.apply_torque_impulse(torque)

extends Node2D

@export var rockScene: PackedScene
@export var speed: int = 100
@export var torque: int = 200
@export var spawn_timeout: float = 5

@onready var ray: RayCast2D = $RayCast2D

var spawning = false

func _input(event):
	if event is InputEventMouseButton && event.pressed:
		print(event.position)
		_on_rock_spawn()

func _process(_delta):
	if ray.is_colliding():
		_on_rock_spawn()

func _on_rock_spawn():
	if spawning:
		return
	var r = rockScene.instantiate()
	add_child(r)
	
	print(ray.target_position)
	print(r.position)
	r.apply_impulse(ray.target_position*1)

	var torque_force: int
	if ray.target_position.angle_to(Vector2.RIGHT) < 0:
		torque_force = torque * -1
	else:
		torque_force = torque
	r.apply_torque_impulse(torque_force)

	spawning = true
	# Only spawn once
#	get_tree().create_timer(spawn_timeout).timeout.connect(func():
#		spawning = false
#	)

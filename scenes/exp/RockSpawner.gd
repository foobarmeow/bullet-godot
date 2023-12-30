extends Node2D

@export var rockScene: PackedScene
@export var speed: int = 200
@export var torque: int = 200
@export var spawn_timeout: float = 5

@onready var ray: RayCast2D = $RayCast2D

func _ready():
	SignalBus.continue_pressed.connect(_reset)

func _reset():
	spawning = false

var spawning = false
func _process(_delta):
	if ray.is_colliding():
		_on_rock_spawn()

func _on_rock_spawn():
	if spawning:
		return
	var r = rockScene.instantiate()
	add_child(r)
	r.apply_impulse(ray.target_position.normalized()*speed)

	var torque_force: int
	if ray.target_position.angle_to(Vector2.RIGHT) < 0:
		torque_force = torque * -1
	else:
		torque_force = torque
	r.apply_torque_impulse(torque_force)
	r.set_particles(ray.target_position)

	spawning = true

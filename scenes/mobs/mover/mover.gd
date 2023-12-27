class_name Mover extends Node2D

signal burst

enum MovementType {PLAYER_STALK, STOPPED, RANDOM, PATHED = -1}


const animation_by_type = {
	MovementType.RANDOM: "mover",
	MovementType.PATHED: "mover",
	MovementType.STOPPED: "still",
	MovementType.PLAYER_STALK: "stalker",
}

@export var path_speed: float = .01
@export var movement_type: MovementType = MovementType.STOPPED
@export var poppable: bool = true

@export var spawn_type: Constants.SpawnerType = Constants.SpawnerType.TARGET
@export var spawn_time: float = 0.19
@export var bullet: PackedScene
@export var speed: int = 50
@export var dir: Vector2
@export var parry_speed: int = 450


var fill: float = 0
var filling: float = 0
var player: Player
var alerted: bool = false

func _ready():
	$FireTimer.wait_time = spawn_time
	if get_parent().name == "exp":
		player = $Player
		begin() # call begin on exp level


func begin():
	var animation = animation_by_type[movement_type]
	$AnimatedSprite2D.play(animation_by_type[movement_type])
	
func _physics_process(delta):
	if spawn_type == Constants.SpawnerType.TARGET:
		if player != null:
			dir = position.direction_to(player.position)

	if filling > 0: 
		fill += filling * delta
	elif fill > 0:
		fill -= .5 * delta

	if fill >= 1:
		if poppable:
			burst.emit(self)
			queue_free()
	elif fill > .90:
		shake(delta, 4)
	elif fill > 0.75:
		shake(delta, 3)
	elif fill > 0.50:
		shake(delta, 2)
	elif fill > 0.25:
		shake(delta, 1)
	elif fill > 0:
		shake(delta, .25)
		
	match movement_type:
		MovementType.RANDOM:
			# More stuck on walls behaviour
			pass
		MovementType.PATHED:
			# TODO: implement path'd movers
			#var i = path_speed * delta
			#progress_ratio += i
			pass
		MovementType.PLAYER_STALK:
			# NOPE
			# Getting following to work is hard :(
			pass
		MovementType.STOPPED:
			pass

var outside_fill = .25
var inside_fill = .45
func _on_outside_radius_area_entered(area):
	filling = outside_fill
func _on_inside_radius_area_entered(area):
	filling = inside_fill
func _on_inside_radius_area_exited(area):
	filling = outside_fill
func _on_outside_radius_area_exited(area):
	filling = 0

func shake(delta, factor):
	var p = Vector2.from_angle(randf_range(0, TAU)) * delta
	$AnimatedSprite2D.position = p.normalized() * factor

func _on_visible_on_screen_notifier_2d_screen_entered():
	if alerted:
		return
		
	alerted = true
	await get_tree().create_timer(.25).timeout

	$Alert.play("alert")
	$FireTimer.start()

func _on_visible_on_screen_notifier_2d_screen_exited():
	#alerted = false
	#$FireTimer.stop()
	pass
	
func fire():
	if bullet == null:
		return

	match spawn_type:
		Constants.SpawnerType.TARGET:
			var v = dir * speed
			add_bullet(v)
		Constants.SpawnerType.DIR:
			var v = dir * speed
			add_bullet(v)
		Constants.SpawnerType.PLUS:
			for v in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
				add_bullet(v*speed)
		Constants.SpawnerType.CIRCLE:
			var steps = 8
			var angle = 0.0
			var step = TAU/steps
			for i in steps:
				var v = Vector2.UP.rotated(angle) * speed
				add_bullet(v)
				angle += step
				
	$AnimatedSprite2D.play("fire")

func add_bullet(v):
	var b = bullet.instantiate()
	b.position = global_position
	get_tree().root.add_child(b)
	b.velocity = v
	b.speed = speed
	b.from = position
	b.parry_speed = parry_speed
	b.fire()
	
func destroy():
	queue_free()

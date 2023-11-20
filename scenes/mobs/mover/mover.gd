class_name Mover extends CharacterBody2D

signal burst

enum MovementType {PLAYER_STALK, STOPPED, RANDOM, PATHED = -1}

const animation_by_type = {
	MovementType.RANDOM: "mover",
	MovementType.PATHED: "mover",
	MovementType.STOPPED: "still",
	MovementType.PLAYER_STALK: "stalker",
}

@export var path_speed: float = .01
@export var speed: int = 100
@export var offset_from_player: int = 25
@export var movement_type: MovementType
@export var spawner_type: Constants.SpawnerType
@export var poppable: bool = true

var fill: float = 0
var filling: float = 0
var player: Player
var alerted: bool = false


func begin():
	$Spawner.type = spawner_type
	var animation = animation_by_type[movement_type]
	$AnimatedSprite2D.play(animation_by_type[movement_type])

func _physics_process(delta):
	if $Spawner.type == Constants.SpawnerType.TARGET:
		if player != null:
			$Spawner.dir = position.direction_to(player.position)

	if filling > 0:
		fill += filling * delta
	elif fill > 0:
		fill -= .5 * delta

	if fill >= 1:
		if poppable:
			burst.emit(self)
			queue_free()
	elif fill > .90:
		shake(delta, 8)
	elif fill > 0.75:
		shake(delta, 5)
	elif fill > 0.50:
		shake(delta, 3)
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
	$Spawner/FireTimer.start()


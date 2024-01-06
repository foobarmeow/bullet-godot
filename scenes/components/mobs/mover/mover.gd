class_name Mover extends Node2D

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
@export var bullet_color_override: Color
@export var spawn_type: Constants.SpawnerType = Constants.SpawnerType.TARGET
@export var spawn_time: float = 0.19
@export var bullet: PackedScene
@export var speed: int = 100
@export var dir: Vector2
@export var parry_speed: int = 450
@export var health: int = 30:
	get:
		return $DamageManager.health
@export var target: Node2D

var alerted: bool = false
var is_dead: bool = false

func _ready():
	$FireTimer.wait_time = spawn_time
	if get_parent().name == "exp":
		begin() # call begin on exp level

	SignalBus.dead_title.connect(_stop)
	SignalBus.start_pressed.connect(begin)
	SignalBus.continue_pressed.connect(begin)
	SignalBus.fun_part.connect(begin)

func _stop():
	alerted = false
	$FireTimer.stop()

func begin():
	is_dead = false
	$DamageManager.reset()
	$AnimatedSprite2D.play(animation_by_type[movement_type])
	
func _physics_process(_delta):
	if is_dead: 
		return
	if spawn_type == Constants.SpawnerType.TARGET:
		if target != null:
			dir = position.direction_to(target.position)
	if spawn_type == Constants.SpawnerType.ROTATE:
		rotation += TAU/100
		if rotation >= 360:
			rotation = 0
	
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
	

func _on_visible_on_screen_notifier_2d_screen_entered():
	if alerted || is_dead:
		return
		
	alerted = true
	await get_tree().create_timer(.1).timeout

	$Alert.play("alert")
	$FireTimer.start()

func shake(delta, factor):
	var p = Vector2.from_angle(randf_range(0, TAU)) * delta
	$AnimatedSprite2D.position = p.normalized() * factor


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
			fire_circle()
		Constants.SpawnerType.ROTATE:
			fire_circle()
			
	#$AnimatedSprite2D.play("fire")

func fire_circle():
	var steps = 8
	var angle = 0.0
	var step = TAU/steps
	var v = Vector2.UP.rotated(rotation)
	for i in steps:
		var rv = v.rotated(angle) * speed
		add_bullet(rv)
		angle += step
		
		
func add_bullet(v):
	var b = bullet.instantiate()
	b.position = global_position
	get_tree().root.add_child(b)
	b.velocity = v
	b.speed = speed
	b.from = position
	b.parry_speed = parry_speed
	if bullet_color_override:
		b.modulate = bullet_color_override
	b.fire()

func take_damage(d: int, enemy: Node2D):
	var dmgmgr = $DamageManager
	if dmgmgr:
		dmgmgr.take_damage(self, enemy, d)


func take_damage_from(d: int, enemy: Node2D, from: Vector2):
	take_damage(d, enemy)
	$DamageParticles.process_material.direction = Vector3(from.x, from.y, 0)
	$DamageParticles.emitting = true


func _on_damage_manager_health_updated(new_health: int, _init_health: int):
	if new_health <= 0:
		$FireTimer.stop()
		var death_anim = "%s_dead" % animation_by_type[movement_type]
		$AnimatedSprite2D.play(death_anim)
		is_dead = true
		SignalBus.enemy_dead.emit()
		


func _on_visible_on_screen_notifier_2d_screen_exited():
	alerted = false
	$FireTimer.stop()

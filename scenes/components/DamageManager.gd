class_name DamageManager extends Node2D

signal health_updated
signal invuln_updated

@export var health: int
@export var invuln: bool = false
@export var hit_grace: int = 0
@export var hit_color: Color = Color.RED
@export var invuln_time: float

var is_ready: bool = false

var _health: int = health:
	set(v):
		_health = v
		print("HEALTH UPDATED", is_ready)
		if is_ready:
			health_updated.emit(_health, health)
		
var _invuln: bool = invuln:
	set(v):
		_invuln = v
		invuln_updated.emit(_invuln)
		
var taking_damage: bool = false
	
func _ready():
	print("READY", health)
	_health = health
	is_ready = true
	pass
	
func end_invuln():
	_invuln = false
	
func take_damage(parent: Node2D, enemy: Node2D, dmg: int):
	# free the enemy right away...
	enemy.queue_free()
	
	if _invuln:
		return
	

	if invuln_time > 0:
		_invuln = true
		get_tree().create_tween().tween_callback(end_invuln).set_delay(invuln_time)
		
	if _health <= 0:
		return

	print("TAKING DAMAGE", dmg)
	_health -= dmg
	damage_animate(parent)
	


var tweens: Array[Tween]
func damage_animate(parent: Node2D):
	for t in tweens:
		t.kill()
	tweens = []
		
	var initial_position = parent.position

	
	var tween = get_tree().create_tween()
	tweens.append(tween)
	
	for i in 5:
		var p = Vector2(parent.position.x+randi_range(-2, 2), parent.position.y+randi_range(-2,2))
		tween.tween_property(parent, "position", p, .025)
	# Back to initial position
	tween.tween_property(parent, "position", initial_position, .025)

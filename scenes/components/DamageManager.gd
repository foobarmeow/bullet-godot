class_name DamageManager extends Node2D

var parent: Node2D
var health: int
var can_hit: bool = true
var can_damage: bool = true
var taking_damage: bool = false
var hit_grace: int = 0
var hit_color: Color = Color.RED

func _init(_parent: Node2D):
	parent = _parent
	
func take_damage(dmg: int, enemy: Node2D):
	if !can_hit || taking_damage:
		return
		
	# No damage will be taken if health is < 0
	if health <= 0:
		return
		
	# See if the parent has a callback to let us know
	# if we should allow the hit or not
	if parent.has_method("allow_hit"):
		if !parent.allow_hit():
			return

	if !can_damage: 
		return
		
	taking_damage = true
	health -= dmg
	damage_animate()


func damage_animate():
	var initial_position = parent.position
	var initial_color = parent.modulate
	var color_tween = get_tree().create_tween()
	color_tween.tween_property(parent, "modulate", Color.RED, .05)
	color_tween.tween_property(parent, "modulate", initial_color, .05)
	var tween = get_tree().create_tween()
		# 5 frames
	for i in 5:
		var p = Vector2(position.x+randi_range(-2, 2), position.y+randi_range(-2,2))
		tween.tween_property(parent, "position", p, .025)
	# Back to initial position
	tween.tween_property(parent, "position", initial_position, .025)
	
		


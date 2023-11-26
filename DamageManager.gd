extends Node2D

var health: int
var hittable: bool = true
var taking_damage: bool = false
var hit_grace: int = 0

func take_damage(dmg: int, enemy: Node2D):
	if !hittable || taking_damage:
		return
	if health > 0:
		# Give just a couple frames of leway for them to parry
		await get_tree().create_timer(hit_grace).timeout
		if enemy != last_parried:
			if damageable:
				taking_damage = true
				health -= d
				print(health)
			if hittable:
				sprite.modulate = Color("ff0000")
				get_tree().create_timer(.25).timeout.connect(func():
					sprite.modulate = initial_modulate
				)
			if is_instance_valid(enemy):
				enemy.queue_free()
			await get_tree().create_timer(i_time).timeout
			taking_damage = false

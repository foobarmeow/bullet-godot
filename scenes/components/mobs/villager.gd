extends Node2D

enum VillagerType { A, B, C, D = 1}

@export var villager_type: VillagerType = VillagerType.D

func _ready():
	$AnimatedSprite2D.play("idle_%s" % villager_type)
	

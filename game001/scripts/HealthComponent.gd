extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 10.0
@export var health_bar : HealthBar

signal health_change(health)

var health : float

func _ready():
	health = MAX_HEALTH
	
func damage(attack: Attack):
	health -= attack.attack_damage
	health_change.emit(health)
	print("health is now: " + str(health))
	
	if health <= 0:
		get_parent().queue_free()





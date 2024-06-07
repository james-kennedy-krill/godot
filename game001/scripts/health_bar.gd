extends Node2D
class_name HealthBar

var total_health := 100

func adjust_damage(health):
	total_health -= clamp(health, 0, 100)

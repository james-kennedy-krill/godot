extends Control

@export var player1 : Tank
@export var player2 : Tank

@onready var player_1 = $Player1
@onready var player_2 = $Player2


func _ready():
	print(player1.health)
	print(player2.health)
	player_1.init_health(player1.health)
	player_2.init_health(player2.health)


func _on_player_1__take_damage(damage):
	print(damage)
	print(player_1.health)
	var new_value = player_1.health - damage
	print(new_value)
	player_1.health = new_value


func _on_player_2__take_damage(damage):
	print(damage)
	print(player_2.health)
	var new_value = player_2.health - damage
	print(new_value)
	player_2.health = new_value

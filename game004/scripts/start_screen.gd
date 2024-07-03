extends Node3D

@onready var button = $Control/VBoxContainer/Button



func _on_button_button_up():
	get_tree().change_scene_to_file("res://scenes/game.tscn")

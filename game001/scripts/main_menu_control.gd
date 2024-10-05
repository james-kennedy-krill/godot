extends Control

@onready var PlayButton = $MarginContainer/VBoxContainer/Play

func _ready():
	PlayButton.grab_focus()



func _on_options_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")

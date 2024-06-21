extends Area2D

@export var next_scene := "res://scenes/levels/level2.tscn"
@onready var panel = $CanvasLayer/Panel

var entered := false

func _on_body_entered(body: Player):
	entered = true
	panel.visible = true


func _on_body_exited(body: Player):
	entered = false
	panel.visible = false

func _process(delta):
	if entered == true:
		if Input.is_action_just_pressed("action"):
			get_tree().change_scene_to_file(next_scene)

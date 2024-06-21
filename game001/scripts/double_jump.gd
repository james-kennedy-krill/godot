extends Area2D
class_name DoubleJump

@onready var game_manager = %GameManager
@onready var animation_player = $AnimationPlayer


func _on_body_entered(body: Player):
	game_manager.DOUBLE_JUMP = true
	animation_player.play("pickup")

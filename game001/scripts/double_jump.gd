extends Area2D
class_name DoubleJump

@onready var animation_player = $AnimationPlayer


func _on_body_entered(body: Player):
	GameManager.DOUBLE_JUMP = true
	animation_player.play("pickup")

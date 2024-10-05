extends RigidBody2D

@export var speed = -750
@export var damage = 10

@onready var explosion = $Explosion
@onready var explosion_animation = $Explosion/AnimationPlayer
@onready var shoot_sound = $ShootSound

func _ready():
	$ShootSound.play()
	explosion.visible = false

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body is Tank:
		body.take_damage(damage)
	freeze = true
	explosion_animation.play("explode")

func remove():
	queue_free()

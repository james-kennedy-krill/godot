extends Node2D


const SPEED = 60

var direction = 1

@export var attack_damage := 1.0
@export var knockback_force := 100.0
@export var stun_time := 1.5

@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var animated_sprite = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
		
	position.x += direction * SPEED * delta


func _on_hitbox_component_body_entered(body):
	if body.is_in_group("Player"):
		print("body has hitbox component")
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.knockback_force = knockback_force
		attack.attack_position = global_position
		attack.stun_time = stun_time
		body.damage(attack)

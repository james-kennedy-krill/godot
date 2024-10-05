extends RigidBody2D

@export var max_speed: float = 300.0
@export var acceleration: float = 75.0
@export var deceleration: float = 200.0
@export var spin_power = 10000
@export var SmallBullet : PackedScene

@onready var boosters: AnimatedSprite2D = $Boosters
@onready var boosters_left: AnimatedSprite2D = $BoostersLeft
@onready var boosters_right: AnimatedSprite2D = $BoostersRight
@onready var gun_1: Marker2D = $Ship/Gun1


var current_speed: float = 0.0
var moving: bool = false
var rotation_dir = 0

func get_input():
	if Input.is_action_just_pressed("shoot"):
		shoot()
	rotation_dir = Input.get_axis("rotate_left", "rotate_right")
	if Input.is_action_pressed("thrust"):
		moving = true
		if rotation_dir == 0:
			$BoostersLeft.visible = false
			$BoostersRight.visible = false
			$Boosters.visible = true
		elif rotation_dir < 0:
			$BoostersLeft.visible = true
			$BoostersRight.visible = false
			$Boosters.visible = false
		else:
			$BoostersLeft.visible = false
			$BoostersRight.visible = true
			$Boosters.visible = false
	else:
		moving = false
		if rotation_dir == 0:
			$BoostersLeft.visible = false
			$BoostersRight.visible = false
			$Boosters.visible = false
		elif rotation_dir < 0:
			$BoostersLeft.visible = true
			$BoostersRight.visible = false
			$Boosters.visible = false
		else:
			$BoostersLeft.visible = false
			$BoostersRight.visible = true
			$Boosters.visible = false
	

func _physics_process(delta):
	get_input()
	constant_torque = rotation_dir * spin_power * delta
	var force_direction = Vector2(cos(rotation), sin(rotation))
	if moving:
		current_speed += acceleration * delta
		if current_speed > max_speed:
			current_speed = max_speed
		apply_central_force(force_direction * current_speed)
	else:
		if current_speed > 0:
			current_speed -= deceleration * delta
			if current_speed < 0:
				current_speed = 0
		apply_central_force(force_direction * current_speed)
		
	

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed

func shoot():
	var b = SmallBullet.instantiate()
	get_tree().root.add_child(b)
	b.transform = gun_1.global_transform

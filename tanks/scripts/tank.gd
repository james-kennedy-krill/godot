extends CharacterBody2D
class_name Tank

@export_range(0,100) var health : int = 100

@export_category("Player Info")
@export var player_number = 1
@export var SPEED = 200.0
@export var JUMP_VELOCITY = -300.0
@export var ROTATION_SPEED = 75.0
@export var PROJECTILE_SPEED = 700
@export var projectile_scene : PackedScene
@export var cockpit_texture : CompressedTexture2D
@export var health_bar : Bar

enum Projectiles {MISSLE_01, MISSLE_02, MISSLE_03}

@export_category("Power Ups")
@export var JUMP = false
@export var FLY = false
@export var DOUBLE_SHOT = false
@export var SHIELD = false
@export var PROJECTILE : Projectiles = Projectiles.MISSLE_01

@onready var screensize = get_viewport_rect().size
@onready var gun_01 = $TankParts/Gun01
@onready var muzzle = $TankParts/Gun01/Muzzle
@onready var cockpit = $TankParts/Cockpit
@onready var collider = $CollisionPolygon2D

var tanksize = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal _take_damage(damage:int)

func _ready():
	tanksize = cockpit.texture.get_size()
	cockpit.texture = cockpit_texture
	health_bar.init_health(health)

func _process(delta):
	if Input.is_action_pressed("rotate_left_" + str(player_number)):
		gun_01.rotation_degrees -= ROTATION_SPEED * delta
	if Input.is_action_pressed("rotate_right_" + str(player_number)):
		gun_01.rotation_degrees += ROTATION_SPEED * delta
	gun_01.rotation_degrees = clamp(gun_01.rotation_degrees, -80.0, 80.0)
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Handle Jump
	# if Input.is_action_just_pressed("jump") and is_on_floor():
	#   velocity.y = JUMP_VELOCITY
	
	# Handle shoot if on the floor
	if Input.is_action_just_pressed("shoot_" + str(player_number)):
		if is_on_floor():
			_shoot()
	
	var direction = Input.get_axis("left_" + str(player_number), "right_" + str(player_number))
	if direction:
		velocity.x = direction * SPEED
		rotation += direction * 0.01
		rotation = clampf(rotation, -0.1, 0.1)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		rotation = move_toward(rotation, 0, 0.01)
		
	move_and_slide()


func _shoot():
	# instantiate projectile
	var p: RigidBody2D = projectile_scene.instantiate()
	get_tree().root.add_child(p)
	# give it velocity in the direction that the canon is facing
	p.transform = muzzle.global_transform
	var dir = Vector2.from_angle(gun_01.rotation - PI/2)
	p.apply_impulse(dir * PROJECTILE_SPEED)
	

func take_damage(damage):
	health_bar.health = health_bar.health - damage
	_take_damage.emit(damage)


func _on_bar_die():
	print("you died")
	for packed_scene in %PhantomCamera2D.follow_targets:
		if packed_scene == self:
			%PhantomCamera2D.follow_targets.erase(packed_scene)
			queue_free()
			%WinScreen.visible = true
			%PlayAgainButton.grab_focus()
			break
			
	

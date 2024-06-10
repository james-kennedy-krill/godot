extends CharacterBody2D

signal leveled_up(msg)
signal xp_increased(val, val_pct)

@export var SPEED = 130.0
@export var JUMP_VELOCITY = -300.0
@export var INCREASE_XP_BY := 5
@export var NEW_LEVEL_AT := 200


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# character attributes
var xp := 0
var xp_pct: int:
	get:
		return (xp * 100) / NEW_LEVEL_AT
	set(value):
		xp = (int(value) * NEW_LEVEL_AT) / 100
		
var level := 1

@onready var animated_sprite = $AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var player_level = %PlayerLevel
@onready var player_level_progress = %PlayerLevelProgress

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_sound.play();
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_timer_timeout():
	xp += INCREASE_XP_BY
	if xp >= NEW_LEVEL_AT:
		xp = 0
		level += 1
		leveled_up.emit("Level up! Now level " + str(level))
	xp_increased.emit(xp, xp_pct)


func _on_leveled_up(msg):
	player_level.text = str(level)
	print(msg)



func _on_xp_increased(val, val_pct):
	player_level_progress.value = val_pct

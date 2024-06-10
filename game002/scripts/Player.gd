extends CharacterBody2D


const SPEED = 300.0

@onready var animated_sprite = $AnimatedSprite2D


func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction.x > 0:
		animated_sprite.flip_h = false
	if direction.x < 0:
		animated_sprite.flip_h = true
	
	if direction:
		animated_sprite.play("run")
		velocity = direction * SPEED
	else:
		animated_sprite.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

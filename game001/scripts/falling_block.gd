extends RigidBody2D

@onready var sprite = $Sprite
@onready var ray_cast_up = $RayCastUp
@onready var timer = $FallTimer
@onready var respawn_timer = $RespawnTimer
@onready var on_screen_notifier = $VisibleOnScreenNotifier2D
@onready var animation_player = $AnimationPlayer

var o_pos


# Called when the node enters the scene tree for the first time.
func _ready():
	freeze = true
	o_pos = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ray_cast_up.is_colliding():
		print("collided!")
		timer.start()
		
func reset_block():
	sprite.scale = Vector2(0, 0)
	position = o_pos
	freeze = true
	animation_player.play("regenerate")

func _on_timer_timeout():
	freeze = false
	respawn_timer.start()

func _on_respawn_timer_timeout():
	reset_block()

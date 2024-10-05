extends StaticBody2D

@export var flip_beam : bool
@onready var beam_sprite = $BeamSprite


func _ready():
	if flip_beam:
		beam_sprite.flip_h = true

extends Node

@export var DOUBLE_JUMP := false

var score = 0
var life = 3

@onready var score_label = $ScoreLabel

func add_point():
	score += 1
	score_label.text = "You collected " + str(score) + " coins."

func remove_life():
	life -= 1

func add_life():
	if life < 3:
		life += 1

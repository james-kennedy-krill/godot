extends Node
class_name GameManager

@export var score := 0
@export var start_time := 3
@export_range(0, 3, 1) var current_level_index: int = 0

var timer_time : int

var stopwatch_running = false
var initial_time = 0

@onready var player : Player = $Player
@onready var levels = $Levels
@onready var hud : Control = $HUD
@onready var countdown_panel : Panel = $HUD/CountdownPanel
@onready var countdown_label : Label = $HUD/CountdownPanel/CountdownLabel
@onready var countdown_timer : Timer = $HUD/CountdownPanel/Timer
@onready var score_label : Label = $HUD/ScorePanel/Score
@onready var level_button: Button = $HUD/LevelCompleted/Panel/MarginContainer/VBoxContainer/Button
@onready var timer_audio_bling = $HUD/CountdownPanel/Bling
@onready var timer_audio_start = $HUD/CountdownPanel/Start
@onready var stopwatch_label : Label = $HUD/TimerPanel/Time
@onready var win_audio = $HUD/LevelCompleted/Win
@onready var camera_animation = $CameraGimbal/CameraAnimation

var current_level
var levels_arr = [
	"res://scenes/level_1.tscn", 
	"res://scenes/level_2.tscn", 
	"res://scenes/level_3.tscn",
	"res://scenes/level_4.tscn"
	]

# Called when the node enters the scene tree for the first time.
func _ready():
	timer_time = start_time
	level_button.connect("button_up", _on_next_level_button_press)
	hud.get_node("LevelCompleted").hide()
	load_next_level()
	connect_level_signals()
	start_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if stopwatch_running:
		get_time()

func connect_level_signals():
	if current_level is Level:
		current_level.connect("level_complete", _on_level_complete)
		current_level.connect("increase_score", add_to_score)

func add_to_score(_score = 1):
	score += _score
	update_score_label()
	
func update_score_label():
	score_label.text = "Score %d" % score
	
func get_score():
	return score
	
func reset_score():
	score = 0
	update_score_label()

func _on_level_complete():
	player.set_controls(false)
	stop_stopwatch()
	hud.get_node("ScorePanel").hide()
	hud.get_node("LevelCompleted").show()
	win_audio.play()
	
	
func _on_next_level_button_press():
	current_level_index += 1
	load_next_level()
	
func start_level():
	player.set_controls(false)
	camera_animation.play("camera_circle")
	stopwatch_label.text = "00:00.00"
	countdown_panel.show()
	timer_audio_bling.play()
	update_timer_display("%d" % start_time)
	countdown_timer.start()
	
func load_next_level():
	# reset things
	reset_score()
	
	# empty out levels
	levels.get_child(0).queue_free()
	
	# load in new level
	if current_level_index < levels_arr.size():
		var new_level = load(levels_arr[current_level_index])
		current_level = new_level.instantiate()
		levels.add_child(current_level)
		connect_level_signals()
	else:
		hud.get_node("LevelCompleted").hide()
		hud.get_node("GameOver").show()
	
	
	# set mouse mode
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hud.get_node("LevelCompleted").hide()
	hud.get_node("ScorePanel").show()
	start_level()

func _on_timer_timeout():
	timer_time -= 1
	if timer_time > 0:
		timer_audio_bling.play()
		update_timer_display("%d" % timer_time)
	if timer_time == 0:
		player.set_controls(true)	
		start_stopwatch()
		timer_audio_start.play()
		update_timer_display("GO!")
	if timer_time < 0:
		countdown_timer.stop()
		countdown_panel.hide()
		timer_time = start_time
		
		
	
func update_timer_display(_text: String):
	countdown_label.text = _text

func start_stopwatch():
	initial_time = Time.get_unix_time_from_system()
	stopwatch_running = true
	
func stop_stopwatch():
	stopwatch_running = false

func get_time():
	var time_now = Time.get_unix_time_from_system()
	var elapsed = time_now - initial_time
	var seconds = int(elapsed) % 60
	var ms = (elapsed - seconds) * 100
	var hours = elapsed / 3600
	var minutes = (elapsed - (3600*hours)) / 60
	var elapsed_time = "%02d:%02d.%02d" % [minutes, seconds, ms]
	stopwatch_label.text = elapsed_time
	

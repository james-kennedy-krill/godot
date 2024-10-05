extends HBoxContainer
class_name Bar

signal die

var health = 0:
	set(new_health):
		print("new health")
		print(new_health)
		var prev_health = health
		health = min(progress_bar.max_value, new_health)
		progress_bar.value = health
		
		if health <= 0:
			die.emit()
			
		if health < prev_health:
			print("took damage")
	
		label.text = str(health) + "/" + str(progress_bar.max_value)


@onready var label = $HPCounter/Label
@onready var progress_bar = $TextureProgressBar

func init_health(_health):
	print("init health")
	print(_health)
	progress_bar.max_value = _health
	health = _health
	

extends Area2D

var speed = 450

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()




func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("mobs"):
		area.queue_free()
	queue_free()

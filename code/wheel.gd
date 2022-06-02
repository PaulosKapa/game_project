extends Area

class_name wheel

var health = 10

signal destroyed

func _process(delta):
	if health<=0:
		emit_signal("destroyed")
		health = 0

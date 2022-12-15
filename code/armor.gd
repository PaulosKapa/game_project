extends Area


class_name armor

export var level = 1
export var endurance = 3

var new_endurance = endurance

func _process(delta):

	if endurance<0:
		queue_free()
	var a = get_overlapping_bodies()
	if new_endurance!=endurance:
		new_endurance = endurance
		print(a)

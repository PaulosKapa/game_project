extends RayCast

var current_collider
var id
var inst
var current_cap
var mag_size
signal pick

func _process(delta):
	var collider = get_collider()
	
	if is_colliding() and collider is magazine:
		if current_collider != collider:
			current_collider = collider
			id = current_collider.get_instance_id()
			inst = instance_from_id(id)
		if Input.is_action_just_pressed("use"):
			emit_signal("pick")

	elif current_collider:
		current_collider = null

	
func getVar():
	current_cap = inst.capacity
	return current_cap

func getVar2():
	mag_size = inst.size_of_mag
	return mag_size

func _on_hand_pick_confirmed():
	current_collider.queue_free()

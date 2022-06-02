extends RayCast

var current_collider
var id
var inst
#gun
var mag_number
var name_of_gun
#car
var passenger
var driver
var seat_pos
var seat
var exit
var gun_seat
var empty_seat = true

signal pick
signal enter

func _process(delta):

	if is_colliding(): 
		var collider = get_collider()
		if collider is gun_drop:
			collider()
			if Input.is_action_just_pressed("use"):
				emit_signal("pick")
				
		elif collider is seats:
			collider()
			if Input.is_action_just_pressed("use") and empty_seat == true:
				emit_signal("enter")

		elif current_collider:
			current_collider = null

func collider():
	var collider = get_collider()
	if current_collider != collider:
			current_collider = collider
			id = current_collider.get_instance_id()
			inst = instance_from_id(id)

#gun
func getVar2():
	mag_number = inst.getVar1()
	return mag_number
	
func getVar3():
	name_of_gun = inst.getVar2()
	return name_of_gun
	
func getVar5():
	return inst

func _on_Player_gun_pick_confirmed():
	current_collider.queue_free()

#car
func setVar6(value):
	inst.setVar_insideCar(value)
	
func getVar7():
	seat_pos = inst.getVar_seatPOS()
	return seat_pos

func set_seat(value):
	inst.setVar_driving(value)

func get_seat():
	seat = inst.getVar_seat()
	if seat == 1:
		driver = inst.setVar_driving(true)
		return driver
	else:
		driver = inst.setVar_driving(false)
		return driver

func get_seat_guns():
	gun_seat = inst.getVar_seat()
	return gun_seat

func get_change_seat():
	if inst.getVar_empty() == true:
		inst.setVar_empty(false)
		empty_seat = inst.getVar_empty()
	else:
		inst.setVar_empty(true)
		empty_seat = inst.getVar_empty()
	return(empty_seat)


func get_exit():
	if inst.getVar_exit() == true:
		exit = inst.setVar_exit(false)
	else:
		exit = inst.setVar_exit(true)
	return exit

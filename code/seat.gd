extends Area

class_name seats

export var seat = 1 #1 for driver, 0 for passenger

var seat_pos
var driving = false
var not_on_car = true

signal drive
signal exit

func _process(delta):
	seat_pos = global_transform.origin
	if driving == true:
		emit_signal("drive")
	if not_on_car == true:
		emit_signal("exit")

func getVar_seatPOS():
	return seat_pos

func setVar_driving(value1):
	driving = value1

func getVar_seat():
	return seat

func setVar_exit(value):
	not_on_car = value

func getVar_exit():
	return not_on_car

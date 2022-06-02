extends RigidBody

class_name gun_drop

export var number_of_mags=[]
export var name_of_gun = 1
export var SPEED = 1

var pick_up = true

func _ready():
	set_as_toplevel(true)
	
func setVar1(value1):
	number_of_mags = value1
	
func getVar1():
	return number_of_mags 

func getVar2():
	return name_of_gun
	
func getVar3():
	return pick_up

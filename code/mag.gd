extends RigidBody

class_name magazine

export var size_of_mag = 1
export var capacity = 30



func _ready():
	set_as_toplevel(true)
	
func _physics_process(_delta):
	apply_impulse(transform.basis.y, -transform.basis.y)


func setVar(value):
	capacity = value
	
func setVar1(value1):
	size_of_mag = value1

func getVar():
	return capacity
	
func getVar1():
	return size_of_mag 

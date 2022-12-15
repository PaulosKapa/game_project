extends RigidBody

class_name battery

export var size_of_mag = 1
export var capacity = 30

var liq = 1

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

func setVarbattery(value):
	liq = value
	$MeshInstance.material_override.set_shader_param("sizey", rand_range(0.0, 1.0) )# liq)
	
func getVarbattery():
	return liq

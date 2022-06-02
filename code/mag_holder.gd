extends Spatial

var magazine_capacity = 30

func _ready():
	set_as_toplevel(true)

func setVar(value):
	magazine_capacity = value

func getVar():
	return magazine_capacity

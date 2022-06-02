extends RigidBody

var destroy = 1
export var SPEED = 1

func _ready():
	set_as_toplevel(true)
	add_to_group("case")
func _physics_process(_delta):
	apply_impulse(transform.basis.z, transform.basis.x * SPEED)
	yield(get_tree().create_timer(destroy), "timeout")

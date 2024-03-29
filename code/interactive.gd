extends RigidBody
class_name Interactive


var target = null


func _physics_process(delta):
	if target:
		global_transform = global_transform.interpolate_with(target.global_transform, delta * 15)


func take(_target):
	target = _target
	mode = RigidBody.MODE_STATIC


func drop():
	target = null
	mode = RigidBody.MODE_RIGID
	var dir = transform.basis.z
	apply_central_impulse(dir * -1)


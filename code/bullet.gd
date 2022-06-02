extends RigidBody

export var SPEED = 1
export var dmg = 10

func _ready():
	set_as_toplevel(true)
	add_to_group("bullet")
	
func _physics_process(_delta):
	apply_impulse(transform.basis.y, -transform.basis.z * SPEED)
	


func _on_Area_body_entered(body):
	if body is enemy:
		body.health-=dmg
		queue_free()
		if body.health<=0:
			body.queue_free()
			
	elif body is car:
		body.health -= dmg
		print("no")
		




func _on_Area_area_entered(area):
	if area is wheel:
		area.health -= dmg

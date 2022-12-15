extends RigidBody

class_name bullet

export var SPEED = 4
var dmg = 10
var level = 3

func _ready():
	set_as_toplevel(true)
	add_to_group("bullet")
	apply_impulse(transform.basis.y, -transform.basis.z * SPEED)

func _on_Area_body_entered(body):
	if body is enemy:
		body.health-=dmg
		if body.health<=0:
			body.queue_free()
		dissapear()
		
	elif body is car:
		body.health -= dmg
		dissapear()
		
	if body.is_in_group("player"):
		body.health -=dmg
		dissapear()

func dissapear():
	hide()
	dmg = 0
	queue_free()


func _on_Area_area_entered(area):
	if area is armor:
		if area.level>=level:
			area.endurance-=1
		else:
			area.endurance -= 1
		dissapear()
		
	elif area is wheel:
		print("1")
		area.health -= dmg
		dissapear()

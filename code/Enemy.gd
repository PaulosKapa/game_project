extends KinematicBody

class_name enemy

signal shoot
signal stop_shoot
signal out_of_ammo

enum{
	IDLE
	ALERT
	HUNT
	AMMO
}

var path = []
var path_node = 0
var speed = 10
var state = IDLE

export var health = 20

onready var gun = $enemy/eyes/Spatial
onready var enemy_node = $enemy
onready var nav = get_parent()



func _physics_process(delta):
	match state:
		HUNT:
			if path_node<path.size():
				var direction = (path[path_node] - global_transform.origin)
				if direction.length() < 15:
					path_node += 1

				else:
					move_and_slide(direction.normalized() * speed, Vector3.UP)
		AMMO:
			if path_node<path.size():
				var direction = (path[path_node] - global_transform.origin)
				if direction.length() < 5:
					path_node += 1
				else:
					move_and_slide(direction.normalized() * speed, Vector3.UP)
				
func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0

func _on_Timer_timeout():
	var target = enemy_node.get_target()
	#print(target)
	if target == null:
	#	print("wait")
		pass
	else:
		move_to(target.global_transform.origin)
	#	print(target.global_transform.origin)


func _on_enemy_alert():
	state = ALERT
	emit_signal("shoot")


func _on_enemy_idle():
	state = IDLE
	emit_signal("stop_shoot")


func _on_enemy_out_of_ammo():
	state = AMMO


func _on_enemy_hunt():
	state = HUNT
	emit_signal("shoot")

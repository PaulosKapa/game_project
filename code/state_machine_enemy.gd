extends Spatial

enum {
	IDLE,
	ALERT,
	STUNNED,
	AMMO,
	HUNT,
	COVER
}



export var ray_path: NodePath
export var eyes_path : NodePath
export var timer_path : NodePath
export var health = 10

var eyes : Spatial
var ray : RayCast
var timer : Timer
var state = IDLE
var target
var out_of_ammo = false
var previous_state = []
var previous_target = []
var one_time = true
var aggressiveness #1 calm, 2 aggressive

onready var ai = get_parent()
onready var gun = $eyes/Spatial

const turn_speed = 2

signal alert
signal idle
signal out_of_ammo
signal hunt

func _ready():
	aggressiveness = randi()%2+1
	timer = get_node(timer_path)
	eyes = get_node(eyes_path)
	ray = get_node(ray_path)
	gun.connect("out_of_ammo", self, "_on_Spatial_out_of_ammo")
	
func _process(delta):

#	if ray.is_colliding():
#		state = ALERT
#	#elif Input.is_action_just_pressed("shoot"):
#	#	state = STUNNED
#	else:
#		state = IDLE
	match state:
		IDLE:
		#	print("idle")
			pass				
		ALERT:
			#print("alert")
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg2rad(eyes.rotation.y * turn_speed))

#			if ray.is_colliding():
#				var hit = ray.get_collider()
#				if hit.is_in_group("player"):
#
#					pass
		HUNT:
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg2rad(eyes.rotation.y * turn_speed))
			
		AMMO:
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg2rad(eyes.rotation.y * turn_speed))
			
		STUNNED:
			print("stunned")


func _on_sight_range_body_entered(body):
	if body.is_in_group("player"):
		match aggressiveness:
			1:
				state = ALERT
				emit_signal("alert")
			2:
				state = HUNT
				emit_signal("hunt")
		previous_state.append(state)
		target = body
		previous_target.append(target)
		timer.stop()

		
	if body is magazine and out_of_ammo == true:
		target = body
		state = AMMO
		timer.stop()
		emit_signal("out_of_ammo")

func _on_sight_range_body_exited(body):
	if body.is_in_group("player"):
		state = IDLE
		emit_signal("idle")
	if body is magazine:
		target = previous_target[0]
		previous_target.remove(0)
		state = previous_state[0]
		previous_state.remove(0)


func _on_Spatial_out_of_ammo():
	out_of_ammo =true

func get_target():
	return(target)



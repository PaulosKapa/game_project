extends VehicleBody

class_name car

export var max_rpm = 500
export var max_torque = 200
export var health = 100
export var speed = 100

var seat_pos
var pass_pos
var pass_pos2
var pass_pos3
var drive = false
var destroyed = false
var flat_tire = 1
var is_flat_lfwd = false

func _process(delta):
	if health <= 0:
		destroyed = true
		health = 0



func _physics_process(delta):
	if drive == true and destroyed == false:
		set_brake(0)
		steering = lerp(steering, Input.get_axis("right","left") * 0.4 , 5 *flat_tire * delta)
		var acceleration = Input.get_axis("backward", "forward") * speed 
		var rpm = $left_wheel_back.get_rpm()
		$left_wheel_back.engine_force = acceleration * max_torque * (1 - (flat_tire*rpm)/max_rpm)
		rpm = $right_wheel_back.get_rpm()
		$right_wheel_back.engine_force = acceleration * max_torque * (1 - (flat_tire*rpm)/max_rpm)
		if Input.is_action_just_pressed("handbrake"):
			set_brake(100)
		elif Input.is_action_just_released("handbrake"):
			set_brake(0)
	if drive == false or destroyed == true:
		set_brake(100)

func _on_drivers_seat_drive():
	drive = true

#works both for exiting vehicle and for seat change
func _on_drivers_seat_exit():
	drive = false

func _on_Area_destroyed():
	if is_flat_lfwd == false:
		flat_tire /= 4/3
		print("yes")
		is_flat_lfwd = true

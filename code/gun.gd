extends Spatial

class_name guns

onready var casing = preload("res://scenes/casing.tscn")
onready var mag_holder_scene = preload("res://scenes/mag_holder.tscn")

export onready var bullet = preload("res://scenes/bullet.tscn")
export onready var gun_drop = preload("res://scenes/gun_drop.tscn")
export onready var mag = preload("res://scenes/mag.tscn")

export var recoil_var = .05
export var magazines = [30, 30]
export var size_of_gun = 1
export var fire_rate = .3
export var change_firemode = true
export var firemode = 1 #semi =1 burst = 2 full = 3
export var type_of_gun = 2.9 #semi =.4 burst = 1 full =1.5, can have 1.4/1.9/2.5/2.9 if i can change firemode
export var reload_time = 1
export var default_position = Vector3()
export var ads_position = Vector3()
export var ads_acc: float = .3
export var default_fov: float = 70
export var ads_fov: float = 55
export var weight = .5
export var ray_path : NodePath
export var muzzle_path : NodePath
export var case_path : NodePath
export var timer_path : NodePath
export var hand_path : NodePath
export var mag_holder_path : NodePath
export var gun_drop_path: NodePath
export var sway_left : Vector3
export var sway_right : Vector3
export var sway_normal : Vector3

var distance
var fired = 0
var can_fire = true
var burst = 0
var reloading = false
var ammo = magazines[0]
var ray : RayCast
var muzzle : Spatial
var case : Spatial
var hand : Spatial
var mag_holder : Spatial
var clicktimer : Timer
var gun_drop_place = Spatial
var reload_value = 0
var drop_mag = 0
var choose_reload = .3
var dropping = false
var clicks = 0
var dropped_recently = false
var bullets_on_mags = 0
var dropped_mag_cap
var mag_position = Vector3()
var gun_position = Vector3()
var muzzle_position = Vector3()
var repeat = 0
var allow_dropping = true
var walling = false
var mouse_mov
var sway_threshold = 1
var sway_lerp = 1

signal pick_confirmed

func _input(event):
	if event is InputEventMouseMotion:
		mouse_mov = -event.relative.x
		

func _ready():
	ray = get_node(ray_path)
	muzzle = get_node(muzzle_path)
	case = get_node(case_path)
	clicktimer = get_node(timer_path)
	hand = get_node(hand_path)
	mag_holder = get_node(mag_holder_path)
	gun_drop_place = get_node(gun_drop_path)
	if magazines.size() > 0:
		$gun/assault_rifle/mag_1.show()
	else: 
		$gun/assault_rifle/mag_1.hide()

func _process(delta):
	if mouse_mov != null:
		if mouse_mov> sway_threshold:
			rotation = rotation.linear_interpolate(sway_left, sway_lerp*delta)
		elif mouse_mov < -sway_threshold:
			rotation = rotation.linear_interpolate(sway_right, sway_lerp * delta)
		else:
			rotation = rotation.linear_interpolate(sway_normal, sway_lerp * delta)
	
	mag_position = mag_holder.global_transform.origin
	gun_position = hand.global_transform.origin
	muzzle_position = muzzle.global_transform.origin
	
	#check if you can shoot
	match firemode:
		3:
			if Input.is_action_pressed("shoot"):
				fire()
		
		_:
			if Input.is_action_just_pressed("shoot"):
				fire()
		
	#check if you can change firemode
	if change_firemode == true and Input.is_action_just_pressed("firemode"):
		change_fire()
		print(firemode)
	
	if reloading == false:
		reload()
	
	if walling == false:
		wall_check()
		
	if walling == true:
		remove_wall()
		
	remove()
	ads_enable()
	check()
	drop()
#fire function
func fire():
	match (firemode): 
		2:
			if can_fire == true and magazines[0]>0 and magazines.size()>0:
				if magazines[0]>3:
					while burst<3:
						dropped_recently = false
						recoil()
						bullet_add()
						case_add()
						magazines[0] -=1
						ammo=magazines[0]
						can_fire = false
						yield(get_tree().create_timer(fire_rate), "timeout")
						burst += 1
						if burst == 3:
							burst = 0
							can_fire = true
							break
				else: 
					while magazines[0]>0:
						dropped_recently = false
						recoil()
						bullet_add()
						case_add()
						magazines[0] -=1
						ammo=magazines[0]
						can_fire = false
						yield(get_tree().create_timer(fire_rate), "timeout")
						if magazines[0] == 0:
							can_fire = true
							break
			else:
				can_fire = false
		
		_:
			if can_fire == true and magazines.size()>0 and magazines[0]>0:
				dropped_recently = false
				recoil()
				bullet_add()
				case_add()
				magazines[0] = magazines[0] -1
				ammo=magazines[0]
				can_fire = false
				yield(get_tree().create_timer(fire_rate), "timeout")
				can_fire = true
			
			else:
				can_fire = false

#reload function
func reload():
	if Input.is_action_just_pressed("reload"):
		clicks+=1
		clicktimer.start()
		
		
	match reload_value:
		2:
			$gun/assault_rifle/mag_1.hide()
			if ammo < 1 and magazines.size()>0: #reloading with 0 bullets
				can_fire = false
				reloading = true
				yield(get_tree().create_timer(reload_time), "timeout")
				magazines.remove(0)
				magazine()
				print(magazines)
				reloading = false
				can_fire = true
				reload_value = 0
					
			elif ammo > 0 and magazines.size()>0:#reload with more the 1 bullets
				reloading = true
				can_fire = false
				magazines[0] -=1
				yield(get_tree().create_timer(reload_time), "timeout")
				magazines.shuffle()
				match dropped_recently:
					false:
						while magazines[0]+1 == ammo:
							magazines.shuffle()
					true: 
						magazines.shuffle()
				magazines[0]+=1
				ammo = magazines[0]
				print(magazines)
				reloading = false
				can_fire = true
				reload_value = 0
				$gun/assault_rifle/mag_1.show()
		1:#dropping
			mag_drop()
				
	
#check magazines. if empty ammo = 0. Else ammo = magazine
func magazine():
	if magazines.empty() == true:
		ammo = 0
		reloading = false
		can_fire = false
	else:
		ammo = magazines[0]

func mag_drop():
	if magazines.size()>0:
		$gun/assault_rifle/mag_1.hide()
		var previous_ammo
		dropped_recently = true
		reloading = true
		can_fire = false
		yield(get_tree().create_timer(reload_time), "timeout")
		var mags = mag.instance()
		mags.set_translation(mag_position)
		get_tree().get_root().add_child(mags)
		if magazines[0]>0:
			mags.setVar(magazines[0]-1)
		else:
			mags.setVar((magazines[0]))
		dropped_mag_cap = mags.getVar()
		previous_ammo = magazines[0]
		magazines.remove(0)
		if magazines.size()>0 and previous_ammo>0:
			magazines[0] += 1
		elif magazines.size()<1 and previous_ammo>1:
			magazines.append(1)
		elif magazines.size()<1 and previous_ammo<1:
			magazines.remove(0)
		previous_ammo = 0
		dropped_mag_cap = 0
		reloading = false
		can_fire = true
		reload_value = 0
		if magazines.size()>0:
			$gun/assault_rifle/mag_1.show()

func seperate_mag_drop():
	$gun/assault_rifle/mag_1.hide()
	var previous_ammo
	reloading = true
	can_fire = false
	yield(get_tree().create_timer(reload_time), "timeout")
	var mags = mag.instance()
	mags.set_translation(mag_position)
	get_tree().get_root().add_child(mags)
	if magazines[0]>0 and repeat == 0:
		mags.setVar(magazines[0]-1)
	elif magazines[0]<1 and repeat == 0:
		mags.setVar(0)
	if repeat>0:
		mags.setVar((magazines[0]))
	dropped_mag_cap = mags.getVar()
	previous_ammo = magazines[0]
	magazines.remove(0)
	if repeat == 0:
		if magazines.size()>0 and previous_ammo>0:
			magazines.append(1)
		elif magazines.size()>0 and previous_ammo<1:
			magazines.append(0)
		elif magazines.size()<1 and previous_ammo>1:
			magazines.append(1)
		elif magazines.size()<1 and previous_ammo == 1:
			magazines.append(1)
	previous_ammo = 0
	dropped_mag_cap = 0
	reloading = false
	can_fire = true
	reload_value = 0
	repeat += 1


#change firemode function
func change_fire():
	match (firemode):
		1: 
			match (type_of_gun):
				1.4:
					firemode = 2
				1.9:
					firemode = 3
				2.9:
					firemode = 2
					
		2: 
			match (type_of_gun):
				1.4:
					firemode = 1		
				2.5:
					firemode = 3
				2.9:
					firemode = 3
		3:
			match (type_of_gun):
				1.9:
					firemode = 1
				2.5:
					firemode = 2
				2.9:
					firemode = 1
				
#ads
func ads_enable():
	if Input.is_action_pressed("ads"):
		transform.origin = transform.origin.linear_interpolate(ads_position, ads_acc)

	else: 
		transform.origin = transform.origin.linear_interpolate(default_position, ads_acc)

#add bullet and recoil
func bullet_add():
	var bullets = bullet.instance()
	muzzle.add_child(bullets)
	
#add casings
func case_add():
	var cases = casing.instance()
	case.add_child(cases )

#add recoil
func recoil():
	hand.rotate_x(rad2deg(0.0001))
	transform.origin = transform.origin.linear_interpolate(Vector3(rand_range(-recoil_var*fired,recoil_var*fired), rand_range(-recoil_var*fired,recoil_var*fired), rand_range(-recoil_var*fired,recoil_var*fired)), 0.2)
	fired += 1

func remove():
	if Input.is_action_just_released("shoot"):
		hand.rotate_x(rad2deg(-0.0001*fired))
		fired = 0

func _on_Timer_timeout():
	if clicks == 1:
		reload_value = 1
	elif clicks == 2:
		reload_value = 2
	clicks = 0
	clicktimer.stop()

func _on_RayCast_pick():
	if ray.getVar2() == size_of_gun:
		print(magazines.insert(1,ray.getVar()))
		emit_signal("pick_confirmed")
	else: 
		print("not same")
		
func check():
	if Input.is_action_just_pressed("check_ammo"):
		print(magazines[0])
		
	if Input.is_action_just_pressed("check_firemode"):
		print(firemode)
		
func drop():
	if Input.is_action_just_pressed("drop") and allow_dropping == true:
		allow_dropping = false
		for i in magazines:
			seperate_mag_drop()
		if magazines.size() == 0:
			magazines.append(0)
		repeat = 0
		var guns = gun_drop.instance()
		guns.set_translation(gun_position)
		guns.setVar1(magazines)
		get_tree().get_root().add_child(guns)
		yield(get_tree().create_timer(reload_time), "timeout")
		queue_free()

func wall_check():
	#if ray.is_colliding(): 
		# Calculating the distance between the laser and a collision point.
		distance = transform.origin.distance_to(ray.get_collision_point())
		if distance<10:
			walling=true
			hand.rotate_x(rad2deg(0.1))
#			if distance>10 and one_time==1:
#				hand.rotate_x(rad2deg(-0.01))
#				one_time=0
func remove_wall():
	distance = transform.origin.distance_to(ray.get_collision_point())
	if distance>10:
			walling=false
			hand.rotate_x(rad2deg(-0.1))

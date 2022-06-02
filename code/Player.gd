extends KinematicBody

onready var gun1 = preload("res://scenes/gun.tscn")

export var speed = 10
export var acceleration = 10
export var gravity = .981
export var jump = 30
export var mouse_sensitivity = .3
export var ray_path : NodePath

var velocity = Vector3()
var camera_x_rotation = 0
var ray = RayCast
var gun_id
var on_foot = true
var allow_weapon1 = true

onready var player = $"."
onready var head =$head
onready var camera =$head/Camera
onready var gun = get_node("head/hand").get_path()

signal gun_pick_confirmed

func _ready():
	ray = get_node(ray_path)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		player.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		var x_delta = event.relative.y * mouse_sensitivity 
		
		if camera_x_rotation + x_delta> -90 and camera_x_rotation + x_delta < 90:
			head.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta 
			
func _process(delta):
	weapon_change()

func _physics_process(delta):
	if on_foot == true:
		var player_basis = player.get_global_transform().basis
		var directions = Vector3()
		var ducked = 0
		
		if Input.is_action_pressed("forward"):
			directions -= player_basis.z
		elif Input.is_action_pressed("backward"):
			directions += player_basis.z
		
		if Input.is_action_pressed("left"):
			directions -= player_basis.x
		elif Input.is_action_pressed("right"):
			directions += player_basis.x
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y += jump
			
		if Input.is_action_pressed("sprint"):
			speed = 20 
			acceleration = 20
		elif Input.is_action_just_released("sprint"):
			speed = 10
			acceleration = 10
		
		directions =directions.normalized()
		
		velocity = velocity.linear_interpolate(directions * speed, acceleration * delta)
		velocity.y -= gravity
			
		velocity = move_and_slide(velocity, Vector3.UP)
	else:
		player.set_translation(ray.getVar7())
		if Input.is_action_just_pressed("use"):
			ray.get_exit()
			ray.get_change_seat()
			on_foot = true
			allow_weapon1 = true
		
func weapon_change():
	if has_node("head/hand"):
		var gun1 = get_tree().get_nodes_in_group("gun")[0]
		if gun1.get_path() == gun:
			if Input.is_action_just_pressed("weapon1") or allow_weapon1 == false:
				gun1.hide()
				gun1.can_fire = false
				gun1.reloading = true
			elif Input.is_action_just_pressed("weapon2") and allow_weapon1 == true:
				gun1.show()
				gun1.can_fire = true
				gun1.reloading = false

func _on_eyes_pick():
	if ray.getVar3() == 1:
		var guns = gun1.instance()
		gun_id = ray.getVar5()
		#guns.pick_up = ray.getVar4()
		guns.magazines = ray.getVar2()
		head.add_child(guns)
		emit_signal("gun_pick_confirmed")


func _on_eyes_enter():
	ray.get_exit()
	ray.get_seat()
	ray.get_change_seat()
	on_foot = false
	if ray.get_seat_guns() == 1:
		allow_weapon1 = false

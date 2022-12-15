extends Spatial

class_name bag

onready var player = ("res://scenes/Player.tscn")

export var size_left = 10

func _process(delta):
	print (player) 

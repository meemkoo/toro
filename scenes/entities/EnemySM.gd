#SM stands for State machine
extends Node3D
enum {
	IDLE,
	ALERT,
}

var state = IDLE

@onready var raycast = $RayCast3D 

func _ready():
	pass

func _process(delta):
		
	match state:
		IDLE:
			pass
		ALERT:
			pass

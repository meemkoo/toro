#SM stands for State machine
extends Node3D

enum {
    IDLE,
    ALERT,
}

var state = IDLE

@onready var raycast = $CharacterBody3D/RayCast3D
@onready var eyes = $CharacterBody3D/eyes
@onready var rng = RandomNumberGenerator.new()
@onready var shoottimer = $CharacterBody3D/ShootTimer


var target

const TURN_SPEED = 2

func _ready():
    pass

func _process(delta):
	if Global.gamestart == 0:
		state = IDLE
		
	match state:
		IDLE:
			pass
		ALERT:
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg_to_rad(eyes.rotation.y * TURN_SPEED))
			
			var my_random_number = rng.randf_range(1, 3)
			var units
			[ 
				$alert.play(),
				$alert2.play(),
				$alert3.play(),
			]
			return
			units.pick_random()


func _on_sightrange_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		state = ALERT
		target = body
		shoottimer.start()
	


func _on_sightrange_body_exited(body: Node3D) -> void:
	state = IDLE
	shoottimer.stop()


func _on_shoot_timer_timeout() -> void:
	$AudioStreamPlayer3D.play()
	$CharacterBody3D/RayCast3D/GPUParticles3D.emitting = true
	
	if raycast.is_colliding():
		var hit = raycast.get_collider()
		if hit.is_in_group("Player"):
			print("Hit!")
			$AudioStreamPlayer.play()
			
			await get_tree().create_timer(1.0).timeout
			get_tree().change_scene_to_file("res://scenes/deathscreen.tscn")

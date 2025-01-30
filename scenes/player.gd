extends CharacterBody3D

var speed
var WALK_SPEED = 5.0
const SENSITIVITY = 0.003
var falling = false
var runmaxxing = 0
var walk_vel = Vector3.ZERO
var grav_vel = Vector3.ZERO

#bob vars
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

#fov vars
const BASE_FOV = 80.0
const FOV_CHANGE = 1.5

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var hitbox = $Area3D
@onready var blood = $blood
@onready var enemydeath = $"Head/enemy death sound"

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
    
    if WALK_SPEED >= 10:
        WALK_SPEED = 10
    
    
    if event is InputEventMouseMotion:
        head.rotate_y(-event.relative.x * SENSITIVITY)
        camera.rotate_x(-event.relative.y * SENSITIVITY)
        camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
        
    if Input.is_action_pressed("w_pres"): runmaxxing = 1
    
    for body in hitbox.get_overlapping_bodies():
        #print (body)
        #pass
        if body.is_in_group("Enemy"):
            var body1: Node3D = body
            body1.get_parent().blood.emitting = true
            body.queue_free()
            enemydeath.play()
            WALK_SPEED = WALK_SPEED + 0.5
            print(WALK_SPEED)
        if body.is_in_group("Wall"):
            #pass
            WALK_SPEED = 5

func _physics_process(delta):

# Add the gravity.
    grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)

        
    var move_dir = Vector2(0,1)# runmaxxing * -camera.transform.basis.z.normalized() # Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
    var _forward: Vector3 = -(camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y))
    var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
    walk_vel = walk_vel.move_toward(walk_dir * WALK_SPEED * move_dir.length() * runmaxxing, 100 * delta)
    velocity = walk_vel + grav_vel
      
    var collision = move_and_collide(velocity/4 * delta)
    if collision:
        velocity = velocity.slide(collision.get_normal())

    move_and_slide()
  
    move_and_slide()

# head bob
    t_bob += delta * velocity.length() * float(is_on_floor())
    camera.transform.origin = _headbob(t_bob)
    
    #FOV
    var velocity_clamped = clamp(velocity.length(), 0.5, WALK_SPEED * 2)
    var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
    camera.fov = lerp(camera.fov, target_fov, delta * 12)
    
    #print(camera.fov)
    
    
    
    #Speedlines
    if WALK_SPEED >= 7:
        #apply speedlines
        pass
    else:
        #remove speedlines
        pass


func _headbob(time) -> Vector3:
    var pos = Vector3.ZERO
    pos.y = sin(time * BOB_FREQ) * BOB_AMP
    pos.x = cos(time *BOB_FREQ / 2) *BOB_AMP
    return pos

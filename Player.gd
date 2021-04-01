extends KinematicBody

onready var camera = $Pivot/Camera

export(int) var gravity = -30
export(int) var speed = 12
export(float) var mouse_sensitivity = 0.0006  # radians/pixel

export(int) var jump_speed = 8

var velocity = Vector3()
var jump = false
var friction = 0.5
var ground_acceleration = 0.1

func _ready(): 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

var calculated_speed = 0


func get_input():
	jump = false
	# tabbing out and in
	if Input.is_action_just_pressed("esc"):
		Input.set_mouse_mode(0)
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		if Input.is_action_just_pressed("fire"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	if Input.is_action_pressed("jump"):
		jump = true
	
	# reset

	# actual movement stuff
	var input_dir = Vector3()
	# desired move in camera direction
	if Input.is_action_pressed("move_forward"):
		input_dir += -global_transform.basis.z
	if Input.is_action_pressed("move_back"):
		input_dir += global_transform.basis.z
	if Input.is_action_pressed("strafe_left"):
		input_dir += -global_transform.basis.x
	if Input.is_action_pressed("strafe_right"):
		input_dir += global_transform.basis.x
		
	input_dir = input_dir.normalized()
	return input_dir

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
		
		
func _physics_process(delta):
	velocity.y += gravity * delta
	var desired_dir = get_input()
	
	# velocity = ground_velocity(desired_dir, velocity)
	velocity = ground_velocity_2(desired_dir, speed, velocity, ground_acceleration)
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
	
	calculated_speed = sqrt(velocity.x * velocity.x + velocity.z * velocity.z) 
	$Label.set_text("%.1f" % calculated_speed)

	if jump:
		if is_on_floor() or is_on_wall():
			velocity.y = jump_speed


func ground_velocity_2(wishdir, wishspeed, vel, accel):
	# vel = friction(vel, wishdir, 0.5)
	vel = acceleration(wishdir, wishspeed, vel, accel)
	return vel
	
	
var current_speed = 0
func friction(vel, wishdir, amount):
	if wishdir.x == 0:
		vel.x = lerp(vel.x, 0, amount)
	if wishdir.z == 0:
		vel.z = lerp(vel.z, 0, amount)
	
	return vel
	
func acceleration(wishdir, wishspeed, vel, amount):
	current_speed = vel.dot(wishdir)
	var add_speed = wishspeed - current_speed
	var accel_speed = amount * wishspeed
	if accel_speed > add_speed:
		accel_speed = add_speed

	
	vel.x += accel_speed * wishdir.x
	vel.z += accel_speed * wishdir.z
	
	return vel
	
	


class_name player extends CharacterBody2D

## movement speeds
const move_speed = 300.0
const dash_speed = 750.0

## dashing variables
var dashing = false
var can_dash = true 

## direction variable for get_input_velocity_h()
var horizontal = 0.0
var vertical = 0.0

## gravity
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

## jump time graph
var jump_height : float = 120
var jump_time_to_peak : float = 0.3
var jump_time_to_descent : float = 0.1

## math found on GDC.
var jump_vel : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
var jump_grav : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
var fall_grav : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0


## physics process - functioning as a ready() func.
func _physics_process(delta : float) -> void:
	velocity.y += get_grav() * delta

## if the player inputs a dash and if the player is moving, the velocity of a dash is forced.
	if dashing:
		if get_input_velocity_h() != 0.0:
			velocity.x = get_input_velocity_h() * dash_speed
		if get_input_velocity_v() != 0.0:
			velocity.y = get_input_velocity_v() * dash_speed
	else:
		velocity.x = get_input_velocity_h() * move_speed


## prevents jumping infinitely
	if Input.is_action_pressed("jump") and is_on_floor():
		jump()

## dash input
	if Input.is_action_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		$dash_timer.start()
		

## prevents infinite dashing by resetting once touching the ground.
	if can_dash == false:
		if is_on_floor() == true and dashing == false:
			can_dash = true

	move_and_slide()

## finding gravity
func get_grav() -> float:
	return jump_grav if velocity.y < 0.0 else fall_grav

## jumping function
func jump() -> void:
	if dashing == true:
		velocity.y = dash_speed
	else:
		velocity.y = jump_vel

# gets horizontal input from user
func get_input_velocity_h() -> float:
	horizontal = 0.0

	if Input.is_action_pressed("left"):
		horizontal -= 1.0
	if Input.is_action_pressed("right"):
		horizontal += 1.0

	return horizontal

func get_input_velocity_v() -> float:
	vertical = 0.0

	if Input.is_action_pressed("up"):
		vertical -= 1.0
	if Input.is_action_pressed("down"):
		vertical += 1.0

	return vertical

func _on_dash_timer_timeout() -> void:
	dashing = false
	

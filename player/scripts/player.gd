extends CharacterBody2D

const move_speed = 300.0
const dash_speed = 900.0
var dashing = false
var can_dash = true

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") - 100

var jump_height : float = 100
var jump_time_to_peak : float = 0.2
var jump_time_to_descent : float = 0.1

var jump_vel : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
var jump_grav : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
var fall_grav : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0


func _physics_process(delta : float) -> void:
	velocity.y += get_grav() * delta
	
	if dashing:
		if get_input_velocity() != 0.0:
			velocity.x = get_input_velocity() * dash_speed
	else:
		velocity.x = get_input_velocity() * move_speed
	
	
	if Input.is_action_pressed("jump") and is_on_floor():
		jump()
	
	if Input.is_action_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		$dash_timer.start()
	
	if can_dash == false:
		if is_on_floor() == true:
			can_dash = true
	
	move_and_slide()

func get_grav() -> float:
	return jump_grav if velocity.y < 0.0 else fall_grav

func jump() -> void:
	if dashing == true:
		velocity.y = dash_speed
	else:
		velocity.y = jump_vel

# gets input from user
func get_input_velocity() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("left"):
		horizontal -= 1.0
	if Input.is_action_pressed("right"):
		horizontal += 1.0
	
	return horizontal
	
func _on_dash_timer_timeout() -> void:
	dashing = false

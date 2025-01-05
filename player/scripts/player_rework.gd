extends CharacterBody2D

## Movement settings
const speed = 300.0            # Maximum speed
const acceleration = 700    # Acceleration rate
const deceleration = 800     # Deceleration rate

@onready var dash = $dash

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

## jump time graph
var jump_height : float = 200
var jump_time_to_peak : float = 0.4
var jump_time_to_descent : float = 0.2

## math found on GDC.
var jump_vel : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
var jump_grav : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
var fall_grav : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0

func _physics_process(delta):
	velocity.y += get_grav() * delta
	
	var input_direction = Vector2.ZERO
	
	
	## Get input direction
	if Input.is_action_pressed("right"):
		input_direction.x += 1
	if Input.is_action_pressed("left"):
		input_direction.x -= 1
	
	print(input_direction)
	
	input_direction = input_direction.normalized()  # Normalize diagonal movement

	if input_direction != Vector2.ZERO:
		## Accelerate towards the desired direction
		velocity = velocity.move_toward(input_direction * speed,acceleration * delta)
	
	else:
		## Decelerate to stop
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)

## prevents jumping infinitely
	if Input.is_action_pressed("jump") and is_on_floor():
		jump()



	## Move the player
	move_and_slide()

func get_grav() -> float:
	return jump_grav if velocity.y < 0.0 else fall_grav

## jumping function
func jump() -> void:
	velocity.y = jump_vel

extends CharacterBody2D

## Movement settings
@export var speed = 300.0            # Maximum speed
@export var acceleration = 1100    # Acceleration rate
@export var deceleration = 1200     # Deceleration rate

const DASH_SPEED = 900.0
var dashing = false
var can_dash = true

var hp = 3

@onready var gc := $GrappleController
@onready var GUI := $"../GUI/CanvasLayer"

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

## jump time graph
@export var jump_height : float = 200
@export var jump_time_to_peak : float = 0.4
@export var jump_time_to_descent : float = 0.2

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
	if Input.is_action_pressed("down"):
		input_direction.y += 1
	if Input.is_action_pressed("up"):
		input_direction.y -= 1
	
	
	input_direction = round(input_direction)  # Normalize diagonal movement
	
	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		$Dash/dash_timer.start()
		$Dash/dash_cooldown.start()

	if input_direction != Vector2.ZERO:
		if dashing:
			if input_direction.x != 0:
				velocity.x = input_direction.x * DASH_SPEED
			elif input_direction.y != 0:
				velocity.y = input_direction.y * DASH_SPEED
			elif input_direction.x == 1 and input_direction.y == 1:
				velocity.y = input_direction.y * DASH_SPEED
				velocity.x = input_direction.x * DASH_SPEED
		else:                           ## Accelerate towards the desired direction
			velocity = velocity.move_toward(input_direction * speed, acceleration * delta)
	
	else:
		## Decelerate to stop
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)

## prevents jumping infinitely
	if Input.is_action_pressed("jump") && (is_on_floor() || gc.launched):
		jump()
		take_damage()
		gc.retract()

	## Move the player
	move_and_slide()

func get_grav() -> float:
	return jump_grav if velocity.y < 0.0 else fall_grav

## jumping function
func jump() -> void:
	velocity.y = jump_vel

func take_damage() -> void:
	if hp > 0: 
		hp = hp - 1
		GUI.update_hp()
	elif hp == 0:
		print("died")

func _on_dash_timer_timeout() -> void:
	dashing = false

func _on_dash_cooldown_timeout() -> void:
	can_dash = true

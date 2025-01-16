class_name enemy extends CharacterBody2D

const speed = 100

var health = 80
var health_max = 80
var health_min = 0

var dead : bool = false
var taking_damage: bool
var damage_to_deal = 1
var is_taking_damage : bool

var dir : Vector2
var gravity =  ProjectSettings.get_setting("physics/2d/default_gravity")
var knockback_force = 200

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0
	move(delta)
	
	move_and_slide()

func move(delta):
	if !dead:
		velocity += dir * speed * delta
	elif dead:
		velocity.x = 0


func _on_direction_timer_timeout() -> void:
	$DirectionTimer.wait_time = choose([1.5,2.0,2.5])
	dir = choose([Vector2.LEFT, Vector2.RIGHT])
	velocity.x = 0

func choose(array):
	array.shuffle()
	return array.front() 

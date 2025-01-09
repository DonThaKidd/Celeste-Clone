class_name grapple_controller extends Node2D

@export var rest_length = 2.0
@export var stiffness = 10.0
@export var damping = 2.0

@onready var Player := get_parent()
@onready var raycast := $RayCast2D
@onready var rope := $Line2D

var launched = false
var target : Vector2
var can_grapple = true

func _process(delta):
	raycast.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("Grapple") and can_grapple:
		launch()
		$grapple_cooldown.start()
		$grapple_timer.start()
		can_grapple = false

	if Input.is_action_just_released("Grapple"):
		retract()
	if launched:
		handle_grapple(delta)

func launch():
	if raycast.is_colliding():
		launched = true
		target = raycast.get_collision_point()
		rope.show()

func retract():
	launched = false
	rope.hide()

func handle_grapple(delta):
	var target_dir = Player.get_global_position().direction_to(target)
	var target_dist = Player.get_global_position().distance_to(target)
	
	var displacement = target_dist - rest_length
	
	var force = Vector2.ZERO
	
	if displacement > 0:
		var spring_force_magnitude = stiffness * displacement
		var spring_force = target_dir * spring_force_magnitude
		
		var vel_dot = Player.velocity.dot(target_dir)
		var damping = -damping * vel_dot * target_dir
		
		force = spring_force + damping
	
	Player.velocity += force * delta
	update_rope()

func update_rope():
	rope.set_point_position(1, to_local(target))


func _on_grapple_cooldown_timeout() -> void:
	can_grapple = true


func _on_grapple_timer_timeout() -> void:
	retract()

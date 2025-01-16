extends Area2D

@onready var Player := $"../Player"


func _on_spikes_body_entered(body: Node2D) -> void:
	Player.take_damage()

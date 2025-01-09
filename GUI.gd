extends CanvasLayer

@onready var life_label = $Control/Label
@onready var player = $"../../Player"

func update_hp() -> void:
	life_label.text = "Lives: " + str(player.hp)
	pass

class_name PositionClampComponent
extends Node2D

@export var actor: Node2D
@export var margin: float = 8

var screen_size = Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)

func _process(delta: float) -> void:
	if not actor: return
	
	actor.global_position.x = clamp(actor.global_position.x, margin, screen_size.x - margin)
	actor.global_position.y = clamp(actor.global_position.y, margin, screen_size.y - margin)

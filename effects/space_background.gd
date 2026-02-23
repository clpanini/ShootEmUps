extends ParallaxBackground
@onready var space_layer: ParallaxLayer = %"Space Layer"
@onready var far_stars_layer: ParallaxLayer = %FarStarsLayer
@onready var close_starts_layer: ParallaxLayer = %CloseStartsLayer

func _process(delta: float) -> void:
	space_layer.motion_offset.y += 2 * delta
	far_stars_layer.motion_offset.y += 5 * delta
	close_starts_layer.motion_offset.y += 20 * delta

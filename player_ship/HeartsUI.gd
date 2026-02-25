extends GridContainer

@export var heart_texture: Texture2D
@export var max_hearts: int = 5
@export var heart_size: Vector2 = Vector2(24, 24)

var previous_hp: int = 20

func _ready() -> void:
	columns = max_hearts
	_build()

func _build() -> void:
	while get_child_count() < max_hearts:
		var t := TextureRect.new()
		t.texture = heart_texture
		t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		t.custom_minimum_size = heart_size
		add_child(t)

	while get_child_count() > max_hearts:
		get_child(get_child_count() - 1).queue_free()

func update_hearts(current_hp: int) -> void:
	current_hp = clamp(current_hp, 0, max_hearts * 4)

	if current_hp < previous_hp:
		_blink_heart(current_hp)

	var full_hearts := int(floor(current_hp / 4.0))
	var has_partial := (current_hp % 4) > 0
	if has_partial:
		full_hearts += 1

	for i in range(max_hearts):
		get_child(i).visible = i < full_hearts

	previous_hp = current_hp

func _blink_heart(current_hp: int) -> void:
	var heart_index := int(current_hp / 4)

	if heart_index >= max_hearts:
		return

	var heart := get_child(heart_index)

	var tween := create_tween()
	tween.tween_property(heart, "modulate:a", 0.2, 0.1)
	tween.tween_property(heart, "modulate:a", 1.0, 0.1)
	tween.tween_property(heart, "modulate:a", 0.2, 0.1)
	tween.tween_property(heart, "modulate:a", 1.0, 0.1)

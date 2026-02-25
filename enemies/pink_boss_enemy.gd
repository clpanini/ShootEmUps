extends "res://enemies/enemy.gd"

@export var boss_max_hp: int = 100
@export var boss_scale: float = 1.8

@export var enter_pixels: float = 16.0
@export var enter_speed: float = 120.0

@export var horizontal_speed: float = 160.0
@export var horizontal_margin: float = 24.0

@export var fire_interval: float = 0.6

var _target_y: float
var _phase: int = 0
var _dir: int = 1

func _ready() -> void:
	super._ready()

	scale = Vector2(boss_scale, boss_scale)

	if stats_component:
		stats_component.health = boss_max_hp

	_target_y = global_position.y + enter_pixels

	if laser_rate_timer:
		laser_rate_timer.wait_time = fire_interval
		laser_rate_timer.stop()

func _process(delta: float) -> void:
	if _phase == 0:
		if move_component:
			move_component.velocity = Vector2(0.0, enter_speed)

		if global_position.y >= _target_y:
			global_position.y = _target_y
			if move_component:
				move_component.velocity = Vector2.ZERO
			_phase = 1
			if laser_rate_timer:
				laser_rate_timer.start()
		return

	var w := get_viewport_rect().size.x
	var left := horizontal_margin
	var right := w - horizontal_margin

	if global_position.x <= left:
		global_position.x = left
		_dir = 1
	elif global_position.x >= right:
		global_position.x = right
		_dir = -1

	if move_component:
		move_component.velocity = Vector2(horizontal_speed * float(_dir), 0.0)

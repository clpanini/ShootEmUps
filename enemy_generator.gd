extends Node2D

@export var GreenEnemyScene: PackedScene
@export var PinkBossEnemyScene: PackedScene
@export var margin: float = 8.0

var boss_alive := false
var last_boss_score := 0

@onready var spawner_component: SpawnerComponent = $SpawnerComponent
@onready var green_enemy_spawn_timer: Timer = $GreenEnemySpawnTimer

var game_stats: GameStats

func _ready() -> void:
	var world := get_parent()
	if world:
		game_stats = world.get("game_stats") as GameStats

	if game_stats != null:
		game_stats.score_changed.connect(_on_score_changed)

	green_enemy_spawn_timer.timeout.connect(_on_green_timer_timeout)
	if green_enemy_spawn_timer.is_stopped():
		green_enemy_spawn_timer.start()

func _on_green_timer_timeout() -> void:
	if GreenEnemyScene == null:
		green_enemy_spawn_timer.start()
		return

	spawner_component.scene = GreenEnemyScene
	var screen_width := get_viewport().get_visible_rect().size.x
	var x := randf_range(margin, screen_width - margin)
	spawner_component.spawn(Vector2(x, -16))
	green_enemy_spawn_timer.start()

func _on_score_changed(new_score: int) -> void:
	if boss_alive:
		return
	if new_score <= 0:
		return
	if new_score % 30 != 0:
		return
	if new_score == last_boss_score:
		return

	last_boss_score = new_score
	_spawn_boss()

func _spawn_boss() -> void:
	if PinkBossEnemyScene == null:
		return

	boss_alive = true
	spawner_component.scene = PinkBossEnemyScene

	var screen_width := get_viewport().get_visible_rect().size.x
	var boss = spawner_component.spawn(Vector2(screen_width * 0.5, -16))

	if boss == null:
		boss_alive = false
		return

	boss.tree_exited.connect(func():
		boss_alive = false
		var world := get_parent()
		if world and world.has_method("heal_player"):
			world.heal_player(4)
		elif world and world.has_node("Player"):
			var player = world.get_node("Player")
			if player and player.has_method("heal"):
				player.heal(4)
	)

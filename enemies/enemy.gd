extends Node2D

@onready var stats_component: StatsComponent = $StatsComponent as StatsComponent
@onready var move_component: MoveComponent = $MoveComponent as MoveComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var scale_component: ScaleComponent = $ScaleComponent as ScaleComponent
@onready var flash_component: FlashComponent = $FlashComponent as FlashComponent
@onready var shake_component: ShakeComponent = $ShakeComponent as ShakeComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent as HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent as HitboxComponent
@onready var destroyed_component: DestroyedComponent = $DestroyedComponent as DestroyedComponent
@onready var enemy_laser: Marker2D = $EnemyLaser 
@onready var spawner_component_2: SpawnerComponent = $SpawnerComponent2 as SpawnerComponent
@onready var laser_rate_timer: Timer = $LaserRateTimer
@onready var score_component: ScoreComponent = $ScoreComponent as ScoreComponent

func _ready() -> void:
	laser_rate_timer.timeout.connect(shoot_lasers)

	hurtbox_component.hurt.connect(func(hitbox: HitboxComponent):
		stats_component.health -= 1
		flash_component.flash()
		shake_component.tween_shake()
		scale_component.tween_scale()
		
		if hitbox.owner is Node2D and hitbox.owner.name.containsn("laser"):
			hitbox.owner.queue_free()
	)
	
	hitbox_component.hit_hurtbox.connect(func(hurtbox: HurtboxComponent):
		stats_component.health -= 1
		flash_component.flash()
		shake_component.tween_shake()
	)
	
	stats_component.no_health.connect(func():
		score_component.adjust_score()
		destroyed_component.destroy() 
	)

func _process(delta: float) -> void:
	var bottom := get_viewport_rect().size.y
	if global_position.y >= bottom:
		var ship := get_tree().current_scene.get_node_or_null("Ship")
		if ship:
			ship.stats_component.health -= 1
			ship.hearts_ui.update_hearts(ship.stats_component.health)
		queue_free()

func shoot_lasers() -> void:
	spawner_component_2.spawn(enemy_laser.global_position)
	scale_component.tween_scale()

extends Node2D

@onready var stats_component:  = $StatsComponent as StatsComponent
@onready var move_component:  = $MoveComponent as MoveComponent
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var scale_component:  = $ScaleComponent as ScaleComponent
@onready var flash_component:  = $FlashComponent as FlashComponent
@onready var shake_component:  = $ShakeComponent as ShakeComponent
@onready var hurtbox_component:  = $HurtboxComponent as HurtboxComponent
@onready var hitbox_component:  = $HitboxComponent as HitboxComponent
@onready var destroyed_component:  = $DestroyedComponent as DestroyedComponent
@onready var enemy_laser: Marker2D = $EnemyLaser 
@onready var spawner_component_2: SpawnerComponent = $SpawnerComponent2 as SpawnerComponent
@onready var laser_rate_timer: Timer = $LaserRateTimer
@onready var score_component:  = $ScoreComponent as ScoreComponent

	
func _ready() -> void:
	stats_component.no_health.connect(func():
		score_component.adjust_score()
	)
	
	laser_rate_timer.timeout.connect(shoot_lasers)
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	hurtbox_component.hurt.connect(func(hitbox: HitboxComponent):
		scale_component.tween_scale()
		flash_component.flash()
		shake_component.tween_shake()
	)
	stats_component.no_health.connect(queue_free)
	hitbox_component.hit_hurtbox.connect(destroyed_component.destroy.unbind(1))

func shoot_lasers() -> void:
	spawner_component_2.spawn(enemy_laser.global_position)
	scale_component.tween_scale()

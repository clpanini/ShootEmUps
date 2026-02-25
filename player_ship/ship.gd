extends Node2D

@export var ship_speed: float = 300.0 

@onready var left_gun: Marker2D = $LeftGun
@onready var right_gun: Marker2D = $RightGun
@onready var spawner_component: SpawnerComponent = $SpawnerComponent as SpawnerComponent
@onready var shoot_rate_timer: Timer = $ShootRateTimer
@onready var scale_component: ScaleComponent = $ScaleComponent as ScaleComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $Anchor/AnimatedSprite2D
@onready var move_component: MoveComponent = $MoveComponent as MoveComponent
@onready var flame_animation: AnimatedSprite2D = $Anchor/FlameAnimation

@onready var stats_component: StatsComponent = $StatsComponent as StatsComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent as HurtboxComponent
@onready var flash_component = $FlashComponent 
@onready var shake_component = $ShakeComponent
@onready var hitbox_component = $HitboxComponent

func _ready() -> void:
	hurtbox_component.hurt.connect(func(hitbox: HitboxComponent):
		stats_component.health -= 1
		if flash_component:
			flash_component.flash()
		if shake_component:
			shake_component.tween_shake()
		if hitbox.owner is Node2D:
			hitbox.owner.queue_free()
	)
	
	if hitbox_component:
		hitbox_component.hit_hurtbox.connect(func(hurtbox: HurtboxComponent):
			stats_component.health -= 1
			if flash_component:
				flash_component.flash()
			if shake_component:
				shake_component.tween_shake()
	)
	

	stats_component.no_health.connect(func():
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	)

func _process(delta: float) -> void:
	handle_movement()
	handle_shooting()
	animate_the_ship()
	
	var view_rect = get_viewport_rect().size
	global_position.x = clamp(global_position.x, 8, view_rect.x - 8)
	global_position.y = clamp(global_position.y, 8, view_rect.y - 8)

func handle_movement() -> void:
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	if direction.length() > 0:
		direction = direction.normalized()
	
	move_component.velocity = direction * ship_speed

func handle_shooting() -> void:
	if Input.is_action_pressed("ui_accept"): 
		if shoot_rate_timer.is_stopped():
			shoot_lasers()
			shoot_rate_timer.start()

func shoot_lasers() -> void:
	spawner_component.spawn(left_gun.global_position)
	spawner_component.spawn(right_gun.global_position)
	scale_component.tween_scale()
	
func animate_the_ship() -> void:
	if move_component.velocity.x < 0:
		animated_sprite_2d.play("move_left")
		flame_animation.play("move_left")
	elif move_component.velocity.x > 0:
		animated_sprite_2d.play("move_right")
		flame_animation.play("move_right")
	else:
		animated_sprite_2d.play("center")
		flame_animation.play("center")

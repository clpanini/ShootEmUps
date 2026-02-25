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


func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	handle_movement()
	handle_shooting()
	animate_the_ship()


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

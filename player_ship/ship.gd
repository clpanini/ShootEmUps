extends Node2D

@onready var left_gun: Marker2D = $LeftGun
@onready var right_gun: Marker2D = $RightGun
@onready var spawner_component: SpawnerComponent = $SpawnerComponent as SpawnerComponent
@onready var shoot_rate_timer: Timer = $ShootRateTimer
@onready var scale_component: ScaleComponent = $ScaleComponent as ScaleComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $Anchor/AnimatedSprite2D
@onready var move_component: MoveComponent = $MoveComponent as MoveComponent
@onready var flame_animation: AnimatedSprite2D = $Anchor/FlameAnimation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shoot_rate_timer.timeout.connect(shoot_lasers)
	pass # Replace with function body.

func shoot_lasers() -> void:
	spawner_component.spawn(left_gun.global_position)
	spawner_component.spawn(right_gun.global_position)
	scale_component.tween_scale()
	
func _process(delta: float) -> void:
	animate_the_ship()
	
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
		

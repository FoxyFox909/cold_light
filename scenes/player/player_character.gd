extends CharacterBody2D
class_name PlayerCharacter

signal health_updated(health: int)
signal light_fuel_updated(light_fuel: int)

## Speed of the character, in pixels per second.
@export var move_speed : int = 200

## Maximum health of the character.
@export var max_health : int = 100

## Maximum amount of light fuel. When this runs out, the light cannot be used anymore.
@export var max_light_fuel : int = 100
## How much light_fuel the light takes to remain on per light tick.
@export var light_cost : int = 8

var health : int = max_health : set = set_health
var light_fuel : int = max_light_fuel : set = set_light_fuel

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var camera_2d: Camera2D = $Camera2D
@onready var light: Node2D = $Light

func _ready() -> void:
	@warning_ignore("return_value_discarded")
	EventBus.freezing_damage_tick.connect(_on_freezing_damage_tick)
	health_updated.emit(health)
	light_fuel_updated.emit(light_fuel)
	sprite.play("fly_down")

	#await get_tree().create_timer(2.0).timeout
	#die()

func get_input() -> void:
	var input_direction : Vector2 = Input.get_vector("left", "right", "up", "down")

	velocity = input_direction * move_speed
	if velocity.length() > 0:
		if input_direction.y > 0:
			if light.is_light_on:
				change_animation("fly_down_glow")
			else:
				change_animation("fly_down")
		elif input_direction.y < 0:
			if light.is_light_on:
				change_animation("fly_up_glow")
			else:
				change_animation("fly_up")
		elif absf(input_direction.x) > 0:
			if light.is_light_on:
				change_animation("fly_side_glow")
			else:
				change_animation("fly_side")
			if input_direction.x < 0:
				sprite.flip_h = true
			else:
				sprite.flip_h = false

		## Detect diagonal movement and rotate accordingly
		if absf(input_direction.x) > 0 and absf(input_direction.y) > 0:
			sprite.rotation = input_direction.angle() - (PI / 2)
		else:
			sprite.rotation = 0
	else:
		sprite.rotation = 0
		if light.is_light_on:
			change_animation("fly_down_glow")
		else:
			change_animation("fly_down")

func _physics_process(_delta: float) -> void:
	get_input()
	@warning_ignore("return_value_discarded")
	move_and_slide()
	camera_2d.global_position = position

	#for i:int in get_slide_collision_count():
		#var collision : KinematicCollision2D = get_slide_collision(i)
		#print("Collided with: ", collision.get_collider().name)

## Smoothly transitiosn from animation.
func change_animation(animation_name: String) -> void:
	var current_frame : int = sprite.get_frame()
	var current_progress : float = sprite.get_frame_progress()
	sprite.play(animation_name)
	sprite.set_frame_and_progress(current_frame, current_progress)

func set_light_fuel(value: int) -> void:
	light_fuel = clampi(value, 0, max_light_fuel)
	light_fuel_updated.emit(light_fuel)

func set_health(value: int) -> void:
	health = clampi(value, 0, max_health)
	health_updated.emit(health)
	if health <= 0:
		die()

func needs_resources() -> bool:
	return health < max_health or light_fuel < max_light_fuel

## Firefly fucking dies ;-;
func die() -> void:
	EventBus.freezing_damage_tick.disconnect(_on_freezing_damage_tick)
	set_physics_process(false)
	$CollisionShape2D.set_deferred("disabled", true)
	sprite.pause()
	light.death_light()



func _on_freezing_damage_tick(damage_amount: int) -> void:
	health -= damage_amount


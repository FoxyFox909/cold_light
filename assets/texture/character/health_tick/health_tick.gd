extends CharacterBody2D

## Speed of the tick, in pixels per second.
@export var move_speed : int = 25

## How much health the tick should restore.
@export var health_amount : int = 15

## how much light fuel the tick should restore.
@export var light_fuel_amount : int = 10

@onready var sprite: AnimatedSprite2D = $Sprite

var current_velocity : Vector2

func _ready() -> void:
	sprite.play("crawl")
	randomize_movement()

func _physics_process(_delta: float) -> void:
	velocity = current_velocity
	@warning_ignore("return_value_discarded")
	move_and_slide()
	if get_slide_collision_count() > 0:
		var collision : KinematicCollision2D = get_last_slide_collision()
		if collision.get_collider() is PlayerCharacter:
			var player : PlayerCharacter = collision.get_collider()
			print("collided with player")
			if player.needs_resources():
				feed_player(player)
		randomize_movement()

func randomize_movement() -> void:
	var next_velocity : Vector2 = Vector2.ONE.rotated(randf_range(0, PI * 2)) * move_speed
	current_velocity = next_velocity
	sprite.rotation = next_velocity.angle() + (PI / 2)

func feed_player(player: PlayerCharacter) -> void:
	player.health += health_amount
	player.light_fuel += light_fuel_amount
	queue_free()

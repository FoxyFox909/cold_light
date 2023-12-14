extends Node2D

var is_light_on : bool = false
var is_locked : bool = false
var reload_tween : Tween

@onready var player_character: PlayerCharacter = $".."
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var light_timer: Timer = %LightTimer
@onready var light_reload_timer: Timer = %LightReloadTimer



func _ready() -> void:
	light_timer.timeout.connect(_on_light_timer_timeout)
	light_reload_timer.timeout.connect(_on_light_reload_timer_timeout)

func _process(_delta: float) -> void:
	point_light_2d.visible = is_light_on
	if is_light_on and is_instance_valid(reload_tween):
		reload_tween.kill()

	#print(player_character.light_fuel)

func _draw() -> void:
	if is_light_on:
		print("light on")
		#draw_circle(position, 200, Color.AQUA)

func _input(event: InputEvent) -> void:
	if player_character.light_fuel <= 0 or is_locked:
		return

	if event.is_action_pressed("light"):
		## Gives an initial cost for turning on the light, so it can't be cheese-spammed.
		var initial_turn_on_cost : int
		if player_character.light_cost >> 1 >= 1:
			initial_turn_on_cost = player_character.light_cost >> 1
		else:
			initial_turn_on_cost = 1

		is_light_on = true
		queue_redraw()
		light_timer.start()
		light_reload_timer.stop()


		player_character.light_fuel -= initial_turn_on_cost

	if event.is_action_released("light"):
		is_light_on = false
		queue_redraw()
		light_timer.stop()
		light_reload_timer.start()

func _on_light_timer_timeout() -> void:
	player_character.light_fuel -= player_character.light_cost

	if player_character.light_fuel <= 0:
		light_timer.stop() ## Stop taking away light fuel
		is_light_on = false
		queue_redraw()
		light_reload_timer.start()
		is_locked = true

func _on_light_reload_timer_timeout() -> void:
	_instance_tween()
	reload_tween.tween_property(player_character, "light_fuel", player_character.max_light_fuel, 5)
	reload_tween.tween_callback(func() -> void: is_locked = false)

	#tween.tween_callback(func() -> void: player_character.light_fuel_updated\
			#.emit(player_character.light_fuel))

func _instance_tween() -> Tween:
	reload_tween = get_tree().create_tween()
	return reload_tween

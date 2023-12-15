extends Node2D

var is_light_on : bool = false
var is_locked : bool = false
var reload_tween : Tween

var energy : float = 1.0 : set = set_energy

@onready var player_character: PlayerCharacter = $".."
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var light_timer: Timer = %LightTimer
@onready var light_reload_timer: Timer = %LightReloadTimer



func _ready() -> void:
	light_timer.timeout.connect(_on_light_timer_timeout)
	light_reload_timer.timeout.connect(_on_light_reload_timer_timeout)
	player_character.health_updated.connect(on_player_health_updated)

	#await get_tree().create_timer(2.0).timeout
	#death_light()

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

func death_light() -> void:
	light_timer.stop()
	light_reload_timer.stop()

	is_locked = true
	if is_instance_valid(reload_tween):
		reload_tween.kill()

	is_light_on = true
	energy = 0
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "energy", 1, 0.25)
	tween.tween_property(self, "energy", 0, 0.5).set_delay(0.25)
	tween.tween_property(self, "energy", 1, 0.20).set_delay(0.25)
	tween.tween_property(self, "energy", 0, 0.15)
	tween.tween_property(self, "energy", 0.5, 0.10).set_delay(0.25)
	tween.tween_property(self, "energy", 0, 0.10)
	tween.tween_callback(func() -> void: is_light_on = false)
	tween.tween_property(player_character, "modulate:a", 0.0, .75)
	tween.tween_property($PassiveLight, "energy", 0.0, 0.5)
	tween.tween_callback(func() -> void: tween.kill())


func set_energy(value: float) -> void:
	energy = clampf(value, 0.0, 1.0)
	point_light_2d.energy = energy
	#print("TIMER")
	#print("new light_opacity: ", $Light/PointLight2D.modulate.a)

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

## Recudes energy of the firefly's light, as it reaches lower health.
func on_player_health_updated(health: int) -> void:
	point_light_2d.energy = health as float / player_character.max_health
	pass

func _instance_tween() -> Tween:
	reload_tween = get_tree().create_tween()
	return reload_tween



extends CanvasLayer

@export var player_character : PlayerCharacter

@onready var healthbar: TextureProgressBar = %Healthbar
@onready var light_fuel_bar: TextureProgressBar = %LightFuelBar


func _ready() -> void:
	@warning_ignore("return_value_discarded")
	player_character.health_updated.connect(_on_pc_health_updated)
	player_character.light_fuel_updated.connect(_on_pc_light_fuel_updated)
	await player_character.ready



func _on_pc_health_updated(health: int) -> void:
	var next_healthbar_value : float = (health as float / player_character.max_health) * 100
	healthbar.value = next_healthbar_value

func _on_pc_light_fuel_updated(light_fuel: int) -> void:
	var next_light_fuel_value : float = (light_fuel as float / player_character.max_light_fuel) * 100
	light_fuel_bar.value = next_light_fuel_value

extends Node

## How
@export var damage_per_tick : int = 2

@onready var timer: Timer = $Timer

func _ready() -> void:
	add_to_group("freeze_ticker")
	timer.start()
	timer.timeout.connect(_on_timer_timout)

func stop() -> void:
	timer.stop()

func _on_timer_timout() -> void:
	EventBus.freezing_damage_tick.emit(damage_per_tick)
	#print("freeze tick (", damage_per_tick, " damage)")

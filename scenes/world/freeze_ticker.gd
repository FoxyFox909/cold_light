extends Node

@onready var timer: Timer = $Timer

func _ready() -> void:
	add_to_group("freeze_ticker")
	timer.start()
	timer.timeout.connect(_on_timer_timout)

func stop() -> void:
	timer.stop()

func _on_timer_timout() -> void:
	var damage_amount : int = 2
	EventBus.freezing_damage_tick.emit(damage_amount)
	print("freeze tick (", damage_amount, " damage)")

## Change for github test

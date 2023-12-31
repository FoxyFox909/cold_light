extends CanvasLayer

const level_handler_tscn : PackedScene = preload("res://scenes/level_handler.tscn")

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var firefly_sprite: AnimatedSprite2D = %FireflySprite

func _ready() -> void:
	EventBus.main_menu.connect(_on_main_menu)
	start_button.pressed.connect(_on_start_button_pressed)
	firefly_sprite.play("fly_down")

func _on_start_button_pressed() -> void:
	var level_handler : LevelHandler = level_handler_tscn.instantiate()
	add_sibling(level_handler)
	visible = false

func _on_main_menu() -> void:
	visible = true

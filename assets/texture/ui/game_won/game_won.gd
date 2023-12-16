extends CanvasLayer

## The won-game or game-ended screen.

@onready var gg: Label = $GG
@onready var main_menu_button: Button = $MainMenuButton

func _ready() -> void:

	main_menu_button.visible = false
	main_menu_button.modulate = Color.TRANSPARENT
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)

	gg.scale = Vector2.ZERO
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(gg, "scale", Vector2.ONE, 2.0)
	tween.tween_property(gg, "modulate", Color.TRANSPARENT, 1.5).set_delay(1.5)
	main_menu_button.visible = true
	tween.tween_property(main_menu_button, "modulate", Color.WHITE, 1.25)

func _on_main_menu_button_pressed() -> void:
	EventBus.main_menu.emit()
	queue_free()

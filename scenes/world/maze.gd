extends TileMap

@onready var canvas_modulate: CanvasModulate = $CanvasModulate

func _ready() -> void:
	canvas_modulate.visible = true
	EventBus.game_won.connect(_on_game_won)

func _on_game_won() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(canvas_modulate, "color", Color.WHITE, 2.0)

extends TileMap

@onready var canvas_modulate: CanvasModulate = $CanvasModulate

func _ready() -> void:
	canvas_modulate.visible = true

extends CanvasLayer

## The won-game screen.

@onready var gg: Label = $GG

func _ready() -> void:
	gg.scale = Vector2.ZERO
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(gg, "scale", Vector2.ONE, 2.0)

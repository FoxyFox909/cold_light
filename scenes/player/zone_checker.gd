extends Area2D

@onready var player_character: PlayerCharacter = $".."

func _ready() -> void:
	body_shape_entered.connect(_on_body_shape_entered)

func _on_body_shape_entered(body_rid: RID, body: Node2D,
		_body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMap:
		var coords: Vector2i = body.get_coords_for_body_rid(body_rid)
		var atlas_coords : Vector2i = body.get_cell_atlas_coords(0, coords)

		if atlas_coords == Vector2i(2, 0):
			print("You won!")
			player_character.win()
			EventBus.game_won.emit()

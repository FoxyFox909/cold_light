extends Node

signal freezing_damage_tick(damage_amount: int)
signal game_won
signal main_menu

const won_screen_tscn : PackedScene = preload("res://assets/texture/ui/game_won/game_won.tscn")
const bgm_tscn : PackedScene = preload("res://scenes/sound/bgm.tscn")

func _ready() -> void:
	game_won.connect(_on_game_won)
	var bgm : AudioStreamPlayer = bgm_tscn.instantiate()
	add_sibling.call_deferred(bgm)


func _on_game_won() -> void:
	var won_screen : CanvasLayer = won_screen_tscn.instantiate()
	add_sibling(won_screen)
	get_tree().call_group("freeze_ticker", "stop")

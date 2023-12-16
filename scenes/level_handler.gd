extends Node2D
class_name LevelHandler

const main_menu_tscn : PackedScene = preload("res://scenes/ui/menu/main_menu.tscn")

func _ready() -> void:
	EventBus.main_menu.connect(_on_main_menu)

func _on_main_menu() -> void:
	call_deferred("queue_free")

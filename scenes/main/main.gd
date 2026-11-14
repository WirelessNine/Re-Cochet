extends Node

const CANVAS_COLOR := Color(0.513, 0.565, 0.9, 1.0)
const LEVEL_01: PackedScene = preload("uid://c4f18m7owfw4d")

var current_level: Level2D


func _ready() -> void:
	change_level(LEVEL_01)


func change_level(level_scene: PackedScene) -> void:
	var new_level: Level2D = level_scene.instantiate()
	RenderingServer.set_default_clear_color(new_level.canvas_color)

	add_child(new_level)

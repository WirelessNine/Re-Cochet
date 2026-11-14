extends Node

const CANVAS_COLOR := Color(0.513, 0.565, 0.9, 1.0)


func _ready() -> void:
	RenderingServer.set_default_clear_color(CANVAS_COLOR)

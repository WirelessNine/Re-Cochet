@tool
extends Button

@export var level: PackedScene
@export var level_name: String = "Level 1"

@onready var name_label: Label = $MarginContainer/Name


func _ready() -> void:
	name_label.text = level_name

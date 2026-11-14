@tool
extends Button

const BUTTON_HOVER: TweenPreset = preload("uid://dj1gkfjia4jgt")
const BUTTON_PRESSED: TweenPreset = preload("uid://dhurfiw66vqxb")

@export var level: PackedScene
@export var level_name: String = "Level 1"

@onready var name_label: Label = $MarginContainer/Name


func _ready() -> void:
	name_label.text = level_name

	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _on_button_down() -> void:
	BUTTON_PRESSED.play(self, false)


func _on_button_up() -> void:
	BUTTON_PRESSED.play(self, true)


func _on_mouse_exited() -> void:
	BUTTON_HOVER.play(self, true)


func _on_mouse_entered() -> void:
	BUTTON_HOVER.play(self, false)

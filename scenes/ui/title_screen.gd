extends Menu

const PENTAGON_FULL: AtlasTexture = preload("uid://c7febubhoht5n")

@onready var levels_grid: GridContainer = %LevelsGrid


func _ready() -> void:
	for x: Button in levels_grid.get_children():
		x.pressed.connect(_on_level_button_pressed.bind(x))


func _on_level_button_pressed(button: Button) -> void:
	Globals.level_selected.emit(button.level)


func _opened() -> void:
	for x: Button in levels_grid.get_children():
		var index: int = x.get_index()

		if Globals.completed_levels[index]:
			x.theme_type_variation = &"button_complete"

		if Globals.pentagon_levels[index]:
			x.pentagon_rect.texture = PENTAGON_FULL

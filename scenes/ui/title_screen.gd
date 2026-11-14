extends Menu

@onready var levels_grid: GridContainer = %LevelsGrid


func _ready() -> void:
	for x: Button in levels_grid.get_children():
		x.pressed.connect(_on_level_button_pressed.bind(x))


func _on_level_button_pressed(button: Button) -> void:
	Globals.level_selected.emit(button.level)

extends Node

signal level_selected(level: PackedScene)
signal level_completed
signal pentagon_collected

var completed_levels: Dictionary[int, bool] = {
	0: false,
	1: false,
	2: false,
	3: false,
	4: false,
	5: false,
	6: false,
	7: false,
}

var pentagon_levels: Dictionary[int, bool] = {
	0: false,
	1: false,
	2: false,
	3: false,
	4: false,
	5: false,
	6: false,
	7: false,
}

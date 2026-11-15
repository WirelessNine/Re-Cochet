extends Node

signal level_selected(level: PackedScene)
signal level_failed
signal level_completed

signal pentagon_collected
signal current_hits_changed(new_value: int)

signal shake_camera_requested(strength: float)

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

var pentagon_levels: Dictionary[int, bool] = { 1: false, 3: false, 5: false, 7: false }

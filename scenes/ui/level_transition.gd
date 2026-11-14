extends Menu

@onready var old_level_label: Label = %OldLevel
@onready var new_level_label: Label = %NewLevel
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func play(old_level: int, new_level: int) -> void:
	old_level_label.text = str(old_level)
	new_level_label.text = str(new_level)

	animation_player.play(&"default")

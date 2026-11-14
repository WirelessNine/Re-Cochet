extends Obstacle2D

var colors: Array[Color] = [
	Color(0.667, 0.96, 0.662, 1.0),
	Color(0.662, 0.91, 0.96, 1.0),
	Color(0.96, 0.712, 0.662, 1.0),
	Color(0.915, 0.662, 0.96, 1.0),
	Color(0.727, 0.662, 0.96, 1.0),
	Color(0.662, 0.96, 0.742, 1.0),
	Color(0.935, 0.96, 0.662, 1.0),
	Color(0.96, 0.781, 0.662, 1.0),
	Color(0.662, 0.93, 0.96, 1.0),
]

@onready var sprite: Sprite2D = %Sprite


func _touched() -> void:
	var tween: Tween = create_tween()

	sprite.self_modulate = colors.pick_random()
	sprite.scale = Vector2.ONE * 0.8

	tween.set_parallel(true)

	tween.tween_property(sprite, ^"self_modulate", Color.WHITE, 0.5)
	tween.tween_property(sprite, ^"scale", Vector2.ONE, 0.2)

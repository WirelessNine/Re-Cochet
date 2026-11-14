extends Obstacle2D

const RANDOM_RANGE: int = 5

var activated: bool = false
@onready var sprite: Sprite2D = %Sprite
@onready var shadow: Sprite2D = %Shadow
@onready var collision_shape: CollisionShape2D = %CollisionShape

@export var target_obstacle: Obstacle2D
@export var move_offset: Vector2


func _touched() -> void:
	if activated:
		return

	activated = true
	collision_shape.set_deferred(&"disabled", true)
	shadow.hide()

	_handle_target_obstacle()

	var tween: Tween = create_tween()

	tween.tween_property(sprite, ^"modulate:a", 0.0, 0.3)

	for x: int in 15:
		sprite.position = Vector2.ZERO
		sprite.position = sprite.position.lerp(
			Vector2(
				randf_range(-RANDOM_RANGE, RANDOM_RANGE),
				randf_range(-RANDOM_RANGE, RANDOM_RANGE),
			),
			0.5,
		)
		await get_tree().physics_frame


func _handle_target_obstacle() -> void:
	if not target_obstacle:
		return

	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

	tween.tween_property(target_obstacle, ^"position", move_offset, 0.2).as_relative()

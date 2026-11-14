class_name Level2D
extends Node2D

const SHAKE_FADE: float = 10.0

var _shake_strength: float = 0.0
var pentagon_collected: bool = false

@export var level_id: int = 0
@export var canvas_color: Color
@export var min_hits_required: int = 0

@onready var camera: Camera2D = %Camera
@onready var ball: Player2D = %Ball


func _ready() -> void:
	ball.obstacle_hit.connect(_on_obstacle_hit)

	Globals.pentagon_collected.connect(set.bind(&"pentagon_collected", true))
	Globals.level_completed.connect(_on_level_complete)


func apply_shake(amount: float) -> void:
	_shake_strength = amount


func _process(delta: float) -> void:
	if _shake_strength > 0:
		_shake_strength = lerpf(_shake_strength, 0.0, SHAKE_FADE * delta)
		camera.offset = Vector2(
			randf_range(-_shake_strength, _shake_strength),
			randf_range(-_shake_strength, _shake_strength),
		)


func _on_obstacle_hit() -> void:
	apply_shake(3.0)


func _on_level_complete() -> void:
	ball.movement_disabled = true
	Globals.completed_levels[level_id] = true

	if pentagon_collected:
		Globals.pentagon_levels[level_id] = true

	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

	tween.set_parallel(true)

	tween.tween_property(ball, ^"global_position", ball.start_position, 0.5)
	tween.tween_property(ball, ^"scale", Vector2.ZERO, 0.5)
	tween.tween_property(ball, ^"modulate:a", 0.0, 0.5)

	await tween.finished

	var level_trans_menu: Menu = MenuManager.get_menu("level_transition")

	level_trans_menu.open()

	await get_tree().create_timer(0.7).timeout

	level_trans_menu.play(level_id + 1, level_id + 2)

	await get_tree().create_timer(1.2).timeout

	level_trans_menu.close()

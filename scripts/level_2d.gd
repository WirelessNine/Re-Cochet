class_name Level2D
extends Node2D

@export var level_id: int = 0
@export var canvas_color: Color
@export var min_hits_required: int = 0

var pentagon_collected: bool = false

var current_hits: int = 0

@onready var ball: Player2D = %Ball
@onready var return_point: Area2D = %ReturnPoint


func _ready() -> void:
	ball.obstacle_hit.connect(_on_obstacle_hit)
	current_hits = min_hits_required

	Globals.pentagon_collected.connect(_on_pentagon_collected)
	Globals.level_completed.connect(_on_level_complete)

	Globals.current_hits_changed.emit(clamp(current_hits, 0, 99))


func _exit_tree() -> void:
	Globals.pentagon_collected.disconnect(_on_pentagon_collected)
	Globals.level_completed.disconnect(_on_level_complete)


func kill_player() -> void:
	Globals.shake_camera_requested.emit((15.0))
	ball.movement_disabled = true
	ball.particles.emitting = true
	ball.sprite.hide()


func _on_obstacle_hit() -> void:
	Globals.shake_camera_requested.emit((5.0))

	current_hits -= 1

	if current_hits < 0:
		Globals.level_failed.emit()

	Globals.current_hits_changed.emit(clamp(current_hits, 0, 99))


func _on_pentagon_collected() -> void:
	pentagon_collected = true


func _on_level_complete() -> void:
	ball.movement_disabled = true
	Globals.completed_levels[level_id] = true

	if pentagon_collected:
		Globals.pentagon_levels[level_id] = true

	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

	tween.set_parallel(true)

	tween.tween_property(ball, ^"global_position", return_point.global_position, 0.5)
	tween.tween_property(ball, ^"scale", Vector2.ZERO, 0.5)
	tween.tween_property(ball, ^"modulate:a", 0.0, 0.5)

	await tween.finished

	var level_trans_menu: Menu = MenuManager.get_menu("level_transition")

	level_trans_menu.open()

	await get_tree().create_timer(0.7).timeout

	level_trans_menu.play(level_id + 1, level_id + 2)

	await get_tree().create_timer(1.2).timeout

	level_trans_menu.close()

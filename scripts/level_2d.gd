class_name Level2D
extends Node2D

@export var level_id: int = 0
@export var canvas_color: Color
@export var max_hits: int = 0

var pentagon_collected: bool = false

var current_hits: int = 0

@onready var ball: Player2D = %Ball
@onready var return_point: Area2D = %ReturnPoint


func _ready() -> void:
	ball.obstacle_hit.connect(_on_obstacle_hit)
	current_hits = max_hits

	Globals.pentagon_collected.connect(_on_pentagon_collected)

	Globals.current_hits_changed.emit(clamp(current_hits, 0, 99))


func _exit_tree() -> void:
	Globals.pentagon_collected.disconnect(_on_pentagon_collected)


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

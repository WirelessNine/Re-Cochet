class_name Level2D
extends Node2D

const SHAKE_FADE: float = 10.0

var _shake_strength: float = 0.0

@export var canvas_color: Color
@export var min_hits_required: int = 0

@onready var camera: Camera2D = %Camera
@onready var ball: Player2D = %Ball


func _ready() -> void:
	ball.obstacle_hit.connect(_on_obstacle_hit)


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

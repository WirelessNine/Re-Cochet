class_name Player2D
extends CharacterBody2D

const RETURN_POINT: PackedScene = preload("uid://cfaar6j0h3o0c")

signal obstacle_hit

const SPEED: float = 800.0
const MIN_DISTANCE_FOR_MAX: float = 200.0
const DRAG_PREVIEW_POINT: int = 1

var drag_started: bool = false
var drag_current_pos: Vector2

var drag_direction: Vector2
var drag_distance: float

var drag_disabled: bool = true
var movement_started: bool = false
var movement_disabled: bool = false

var start_position: Vector2
var return_point_created: bool

var hit_effect_tween: Tween

@onready var drag_preview: Line2D = %DragPreview
@onready var sprite: Sprite2D = %Sprite
@onready var hit_effect: Sprite2D = %HitEffect
@onready var particles: GPUParticles2D = %Particles


func _ready() -> void:
	drag_preview.hide()
	hit_effect.show()
	hit_effect.modulate.a = 0.0

	drag_preview.clear_points()
	drag_preview.add_point(Vector2.ZERO)
	drag_preview.add_point(Vector2.ZERO)

	drag_disabled = false


func _physics_process(_delta: float) -> void:
	if not movement_started or movement_disabled:
		return

	var current_velocity: Vector2 = velocity

	move_and_slide()

	_handle_reflection(current_velocity)


func _input(event: InputEvent) -> void:
	if movement_started or drag_disabled:
		return

	if event is InputEventMouseButton:
		if not event.button_index == MOUSE_BUTTON_LEFT:
			return

		if event.is_pressed():
			drag_preview.show()
			drag_preview.set_point_position(DRAG_PREVIEW_POINT, get_local_mouse_position())
			drag_current_pos = get_global_mouse_position()
			drag_started = true
		else:
			drag_direction = drag_current_pos.direction_to(global_position)
			drag_distance = drag_current_pos.distance_to(global_position)
			start_position = global_position
			movement_started = true
			drag_preview.hide()

			_set_directional_velocity()

	if event is InputEventMouseMotion and drag_started:
		drag_current_pos = get_global_mouse_position()
		drag_preview.set_point_position(DRAG_PREVIEW_POINT, get_local_mouse_position())

		if not drag_preview.visible:
			drag_preview.show()


func _set_directional_velocity() -> void:
	var speed_multiplier: float

	if drag_distance >= MIN_DISTANCE_FOR_MAX:
		speed_multiplier = 1.0
	else:
		speed_multiplier = remap(drag_distance, 1.0, MIN_DISTANCE_FOR_MAX, 0.1, 1.0)

	velocity = drag_direction * (SPEED * speed_multiplier)


func _handle_reflection(last_velocity: Vector2) -> void:
	if not is_on_wall():
		return

	var normal: Vector2 = get_wall_normal()

	velocity = last_velocity.bounce(normal)

	var collision: KinematicCollision2D = get_last_slide_collision()

	if collision:
		var collider: Object = collision.get_collider()

		if collider is Obstacle2D:
			collider._touched()
			_play_hit_effect()
			obstacle_hit.emit()


func _play_hit_effect() -> void:
	hit_effect.scale = Vector2.ONE
	hit_effect.modulate.a = 1.0
	sprite.scale = Vector2.ONE * 0.5

	if is_instance_valid(hit_effect_tween):
		hit_effect_tween.kill()

	hit_effect_tween = create_tween()

	hit_effect_tween.set_parallel(true)

	hit_effect_tween.tween_property(hit_effect, ^"scale", Vector2.ONE * 2.0, 0.2)
	hit_effect_tween.tween_property(hit_effect, ^"modulate:a", 0.0, 0.15)
	hit_effect_tween.tween_property(sprite, ^"scale", Vector2.ONE, 0.2)


func _on_area_body_entered(body: Node2D) -> void:
	if body is Obstacle2D:
		body._touched()

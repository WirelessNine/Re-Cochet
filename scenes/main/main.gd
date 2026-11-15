extends Node

const TRANSITION_FADE: TweenPreset = preload("uid://e8fpp0a1aur6")
const SHAKE_FADE: float = 10.0

const CANVAS_COLOR := Color(0.513, 0.565, 0.9, 1.0)
const LEVEL_01: PackedScene = preload("uid://c4f18m7owfw4d")

var current_level: Level2D
var current_level_scene: PackedScene

var _trans_db: bool = false
var _shake_strength: float = 0.0

@onready var camera: Camera2D = %Camera
@onready var fade: ColorRect = %Fade
@onready var title_screen: Menu = %TitleScreen
@onready var current_hits_label: Label = %CurrentHits


func _ready() -> void:
	MenuManager.set_transition(fade, TRANSITION_FADE)

	Globals.level_selected.connect(_on_level_selected)
	Globals.current_hits_changed.connect(
		func(new_value: int) -> void:
			current_hits_label.text = str(new_value),
	)

	Globals.shake_camera_requested.connect(apply_shake)


func _process(delta: float) -> void:
	if _shake_strength > 0:
		_shake_strength = lerpf(_shake_strength, 0.0, SHAKE_FADE * delta)
		camera.offset = Vector2(
			randf_range(-_shake_strength, _shake_strength),
			randf_range(-_shake_strength, _shake_strength),
		)
	else:
		camera.offset = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed(&"back"):
		return

	go_to_title_screen()


func apply_shake(amount: float) -> void:
	_shake_strength = amount


func free_level() -> void:
	if not current_level:
		return

	current_level.ball.drag_disabled = true
	current_level.queue_free()
	current_level = null


func change_level(level_scene: PackedScene) -> void:
	free_level()

	if current_level:
		await current_level.tree_exited

	var new_level: Level2D = level_scene.instantiate()
	RenderingServer.set_default_clear_color(new_level.canvas_color)

	current_level = new_level
	current_level_scene = level_scene

	add_child(new_level)

	current_level.ball.drag_disabled = false


func restart_level() -> void:
	var level_trans_menu: Menu = MenuManager.get_menu("level_transition")

	level_trans_menu.open()

	await get_tree().create_timer(0.5).timeout

	change_level(current_level_scene)

	level_trans_menu.close()

	await get_tree().create_timer(0.5).timeout


func go_to_title_screen() -> void:
	if current_level == null or _trans_db:
		return

	_trans_db = true

	MenuManager.play_transition(true)

	await MenuManager.transition_finished

	free_level()
	title_screen.open()
	_trans_db = false

	MenuManager.play_transition(false)


func _on_level_selected(level: PackedScene) -> void:
	MenuManager.play_transition(true)

	await MenuManager.transition_finished

	change_level(level)
	title_screen.close()

	MenuManager.play_transition(false)


func _on_bounds_body_entered(body: Node2D) -> void:
	if body is Player2D:
		restart_level()

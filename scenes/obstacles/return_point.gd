extends Area2D

@onready var sprite: Sprite2D = %Sprite
@onready var particles: GPUParticles2D = %Particles


func _ready() -> void:
	sprite.scale = Vector2.ONE * 2.0
	sprite.modulate.a = 0.0
	particles.emitting = true

	var tween: Tween = create_tween().set_parallel(true)

	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

	tween.tween_property(sprite, ^"modulate:a", 1.0, 0.2)
	tween.tween_property(sprite, ^"scale", Vector2.ONE, 0.2)


func _on_body_entered(body: Node2D) -> void:
	if body is Player2D:
		Globals.level_completed.emit()

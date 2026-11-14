extends Area2D

var collected: bool = false

@onready var sprite: Sprite2D = %Sprite
@onready var particles: GPUParticles2D = %Particles


func _on_body_entered(body: Node2D) -> void:
	if collected:
		return

	if body is Player2D:
		Globals.pentagon_collected.emit()
		collected = true

		var tween: Tween = create_tween().set_parallel()

		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

		tween.tween_property(sprite, ^"scale", Vector2.ONE * 2.0, 0.4)
		tween.tween_property(sprite, ^"modulate:a", 0.0, 0.35)

		particles.emitting = true

		await particles.finished

		queue_free()

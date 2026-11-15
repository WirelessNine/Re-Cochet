extends Obstacle2D

@onready var sprite: Sprite2D = %Sprite
@onready var collision_shape: CollisionShape2D = %CollisionShape
@onready var particles: GPUParticles2D = %Particles
@onready var hit: AudioStreamPlayer = %Hit


func _touched() -> void:
	particles.emitting = true
	collision_shape.set_deferred(&"disabled", true)

	var tween: Tween = create_tween()

	tween.tween_property(sprite, ^"scale", Vector2.ZERO, 0.2)
	tween.tween_property(sprite, ^"self_modulate:a", 0.0, 0.1)

	hit.play()

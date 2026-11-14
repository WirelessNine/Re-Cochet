shader_type canvas_item;

uniform float amplitude : hint_range(0.0, 50.0, 0.1) = 8.0;
uniform float frequency : hint_range(0.0, 20.0, 0.1) = 1.0;
uniform float speed : hint_range(0.0, 100.0, 0.1) = 45.0;
uniform float damping : hint_range(0.0, 10.0, 0.1) = 0.0;
uniform float pluck_time = 0.0;

void fragment() {
	vec2 uv = UV;
	
	float pin_mask = sin(uv.y * PI);
	
	float elapsed = max(0.0, TIME - pluck_time);
	float decay = exp(-damping * elapsed);
	
	float wave = sin(TIME * speed) * amplitude * pin_mask * decay;
	uv.x += wave;
	
	if (uv.x < 0.0 || uv.x > 1.0) {
		COLOR = vec4(0.0);
	} else {
		COLOR = texture(TEXTURE, uv);
	}
}
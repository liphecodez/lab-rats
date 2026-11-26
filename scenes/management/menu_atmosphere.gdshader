shader_type canvas_item;
render_mode unshaded;

varying vec2 local_position;

float noise(vec2 cell) {
	return fract(sin(dot(cell, vec2(127.1, 311.7))) * 43758.5453);
}

void vertex() {
	local_position = VERTEX;
}

void fragment() {
	vec2 pixel = floor(local_position / 2.0);
	float grain = noise(pixel);
	float fibers = step(0.91, grain) * 0.14;
	float bands = step(7.0, mod(pixel.y, 9.0)) * 0.04;

	// A few bright pixels drift over the paper grain.
	vec2 drift = pixel + floor(vec2(TIME * 1.2, TIME * 2.1));
	vec2 region = floor(drift / 32.0);
	vec2 mote_position = floor(vec2(noise(region), noise(region + 17.0)) * 29.0) + 1.0;
	vec2 distance_to_mote = abs(mod(drift, 32.0) - mote_position);
	float mote = step(distance_to_mote.x + distance_to_mote.y, 0.5);
	mote *= 0.2 + 0.24 * noise(region + 3.0);

	vec2 edge = min(UV, 1.0 - UV);
	float fade = smoothstep(0.0, 0.05, min(edge.x, edge.y));
	vec3 ink = vec3(0.412, 0.106, 0.133);
	vec3 light = vec3(1.0, 0.85, 0.65);
	COLOR = vec4(mix(ink, light, step(0.01, mote)), (max(fibers, bands) + mote) * fade);
}

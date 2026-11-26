extends Button

const FLOAT_HEIGHT := 4.0
const TILT := 0.028
const FLOAT_SPEED := TAU / 1.15

var hovered := false
var rest_position := Vector2.ZERO
var phase := 0.0
var strength := 0.0

func _ready() -> void:
	_add_shadow()
	mouse_entered.connect(_start_hover)
	mouse_exited.connect(_end_hover)
	visibility_changed.connect(_reset_if_hidden)
	set_process(false)

func _add_shadow() -> void:
	var shadow := Panel.new()
	shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shadow.show_behind_parent = true
	shadow.self_modulate = Color(0.14, 0.07, 0.06, 0.4)
	shadow.add_theme_stylebox_override("panel", get_theme_stylebox("normal"))
	add_child(shadow)
	shadow.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shadow.offset_top = 3.0
	shadow.offset_bottom = 3.0

func _start_hover() -> void:
	if disabled:
		return
	if not is_processing():
		rest_position = position
		phase = 0.0
	hovered = true
	set_process(true)

func _end_hover() -> void:
	hovered = false

func _process(delta: float) -> void:
	strength = move_toward(strength, 1.0 if hovered else 0.0, delta * 7.0)
	if is_zero_approx(strength):
		_reset_motion()
		return

	phase += delta * FLOAT_SPEED
	pivot_offset = size * 0.5
	position = rest_position + Vector2(0.0, sin(phase) * FLOAT_HEIGHT * strength)
	rotation = sin(phase + PI * 0.5) * TILT * strength

func _has_point(point: Vector2) -> bool:
	# Keep the clickable rectangle stationary while the button moves.
	var resting_point := get_transform() * point - rest_position if is_processing() else point
	return Rect2(Vector2.ZERO, size).has_point(resting_point)

func _reset_if_hidden() -> void:
	if not is_visible_in_tree() and is_processing():
		_reset_motion()

func _reset_motion() -> void:
	position = rest_position
	rotation = 0.0
	hovered = false
	strength = 0.0
	set_process(false)

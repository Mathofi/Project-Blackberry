extends CharacterBody2D

@export var SPEED = 200.0
@export var POST_DASH_SPEED = 100.0
@export var POST_DASH_SPEED_REDUCTION_TIME = 0.5
@export var DASH_SPEED = 800.0
@export var DASH_TIME = 0.02
@export var DASH_COOLDOWN = 1.0
@export var POST_DASH_BRAKE_TIME = 0.04

const ACCELERATION = 1500.0
const FRICTION = 1000.0
const POST_DASH_FRICTION = 16000.0

var dash_timer = 0.0
var dash_cooldown = 0.0
var dash_direction = Vector2.ZERO
var post_dash_brake_timer = 0.0
var post_dash_slow_timer = 0.0

func _physics_process(delta: float) -> void:
	# Update timers
	if dash_timer > 0.0:
		dash_timer -= delta
	else:
		if dash_cooldown > 0.0:
			dash_cooldown -= delta
		if post_dash_brake_timer > 0.0:
			post_dash_brake_timer -= delta
		if post_dash_slow_timer > 0.0:
			post_dash_slow_timer -= delta

	# Start dash
	if Input.is_action_just_pressed("move_dash") and dash_timer <= 0 and dash_cooldown <= 0:
		_start_dash()

	# Handle dash
	if dash_timer > 0.0:
		velocity = dash_direction * DASH_SPEED
	else:
		# Normal movement
		var input_vector = _get_input_vector()
		var target = Vector2.ZERO

		if input_vector != Vector2.ZERO:
			var current_max_speed = _get_current_max_speed()
			target = input_vector * current_max_speed

		var accel = POST_DASH_FRICTION if post_dash_brake_timer > 0 else (ACCELERATION if input_vector != Vector2.ZERO else FRICTION)
		velocity = velocity.move_toward(target, accel * delta)

	move_and_slide()

func _get_input_vector() -> Vector2:
	var input_vector = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	return input_vector.normalized() if input_vector != Vector2.ZERO else input_vector

func _get_current_max_speed() -> float:
	if post_dash_slow_timer > 0.0:
		var t = 1.0 - (post_dash_slow_timer / POST_DASH_SPEED_REDUCTION_TIME)
		return lerp(POST_DASH_SPEED, SPEED, t)
	return SPEED

func _start_dash() -> void:
	var input_vector = _get_input_vector()
	if input_vector != Vector2.ZERO:
		dash_direction = input_vector
		dash_timer = DASH_TIME
		post_dash_brake_timer = POST_DASH_BRAKE_TIME
		post_dash_slow_timer = POST_DASH_SPEED_REDUCTION_TIME
		dash_cooldown = DASH_COOLDOWN

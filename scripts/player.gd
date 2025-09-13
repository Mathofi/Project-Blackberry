extends CharacterBody2D


@export var SPEED = 200.0 # max speed 
const ACCELERATOIN = 1000.0
const FRICTON = 800.0

## movement
func _physics_process(delta: float) -> void:
	# vector 2 is for bolth axes for (0,0)
	var input_vector = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()

	if input_vector != Vector2.ZERO:
		# accelerat toward the directon 
		var target = input_vector * SPEED
		velocity = velocity.move_toward(target, ACCELERATOIN * delta)
	else:
		# moves twords 0 then no input
		velocity = velocity.move_toward(Vector2.ZERO, FRICTON * delta)

	move_and_slide()

class_name Player
extends CharacterBody3D

@export var speed = 14.0
@export var jump_velocity = 10.0
@export var gravity_multiplier = 4.0
@export var mouse_sensitivity = 0.002
@export var camera: Camera3D
@export var headbobComponent: HeadbobComponent

@export var verticle_limits: Vector2 = Vector2(-90, 90)

var camera_pos = Vector2.ZERO

func _ready() -> void:
	camera_pos = camera.position

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(verticle_limits.x), deg_to_rad(verticle_limits.y))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * gravity_multiplier * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		
		if is_on_floor():
			headbobComponent.headbob(speed, delta)
		
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
		headbobComponent.resetheadposition(delta)

	move_and_slide()

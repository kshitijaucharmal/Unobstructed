extends CharacterBody3D


@export var speed = 14.0
@export var jump_velocity = 10.0
@export var gravity_multiplier = 4.0
@export var mouse_sensitivity = 0.002
@export var camera: Camera3D

@export var verticle_limits: Vector2 = Vector2(-90, 90)
@export var head_bob_amplitude: float = 0.2
@export var head_bob_frequency: float = 0.2
@export var lerp_speed = 10.0

var camera_pos = Vector2.ZERO

var head_bobbing_vector = Vector2.ZERO
var head_bobbing_index = 0.0

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
		
		head_bobbing_index += speed * delta
		
		if is_on_floor():
			head_bobbing_vector.y = sin(head_bobbing_index)
			head_bobbing_vector.x = sin(head_bobbing_index/2)
			
			camera.position.y = lerp(camera.position.y, camera_pos.y + head_bobbing_vector.y*(head_bob_amplitude/2.0),delta * lerp_speed)
			camera.position.x = lerp(camera.position.x, camera_pos.x + head_bobbing_vector.x*head_bob_amplitude,delta * lerp_speed)
		
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
		camera.position.y = lerp(camera.position.y, camera_pos.y, delta * lerp_speed)
		camera.position.x = lerp(camera.position.x, camera_pos.x, delta * lerp_speed)

	move_and_slide()

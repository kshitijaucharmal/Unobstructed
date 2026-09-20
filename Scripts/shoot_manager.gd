extends Node3D

@export var ray_cast_3d: RayCast3D
@export var bullet_decal: PackedScene
@export var scatter_factor := 0.3
@export var scatter_base := 0.8
@export var raycast_target_base:= Vector3(0, 0, -100.0)
@export var shoot_rate := 25
@export var player_controller: Player

var scatter_range := 0.0
var time_between_shots := 0.0
var shot_timer := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_between_shots = 1.0 / shoot_rate
	shot_timer = time_between_shots
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	shot_timer -= delta
	if Input.is_action_pressed("shoot") and shot_timer < 0:
		shot_timer = time_between_shots
		shoot()
	pass

func shoot() -> void:
	var vel = player_controller.get_real_velocity()
	var origin = Vector3.ZERO
	var pos = Vector2.ZERO
	var speed = origin.distance_to(vel)
	
	scatter_range = scatter_base + speed * scatter_factor
	
	var target_position = raycast_target_base
	var theta = randf_range(0, TAU)
	var r = sqrt(randf_range(0.1, 1.0)) * scatter_range

	target_position.x += r * cos(theta)
	target_position.y += r * sin(theta)
	ray_cast_3d.target_position = target_position
	ray_cast_3d.force_raycast_update()
	
	if ray_cast_3d.is_colliding():
		var collision_point: Vector3 = ray_cast_3d.get_collision_point()
		var collision_normal: Vector3 = ray_cast_3d.get_collision_normal()
		var collider: Node3D = ray_cast_3d.get_collider()
		var name = collider.name
		
		var new_bullet: Node3D = bullet_decal.instantiate()
		get_tree().root.add_child(new_bullet)
		new_bullet.position = collision_point

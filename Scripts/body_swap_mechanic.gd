extends Node3D

@export var ray_cast_3d: RayCast3D
@export var player_transform: Node3D
@export var tween_time: float = 0.3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("trigger_swap") and ray_cast_3d.is_colliding():
		var collision_point: Vector3 = ray_cast_3d.get_collision_point()
		var collision_normal: Vector3 = ray_cast_3d.get_collision_normal()
		var collider: Node3D = ray_cast_3d.get_collider()
		var name = collider.name
		
		if collider.is_in_group("Swappable"):
			print("Swappable hit: ", name)
			swap_with(collider)
		else:
			print("Can't swap with ", name)
	pass

func swap_with(target: Node3D):
	var current_pos = player_transform.position
	var tween = create_tween()
	var tween_back = create_tween()

	tween.tween_property(player_transform, "position", target.position, tween_time)
	tween_back.tween_property(target, "position", current_pos, tween_time)
	pass

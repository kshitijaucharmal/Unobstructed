extends Node3D


@export var target: Node3D
@export var lerp_speed: float = 40
@export var copy_position:bool = true
@export var copy_rotation:bool = true

var local_offset = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if target:
		local_offset = target.to_local(global_position)
	pass # Replace with function body.

func _process(delta: float) -> void:
	if not target:
		return

	# 1. Calculate the exact target transform (Position + Rotation combined)
	var target_transform = target.global_transform.translated_local(local_offset)
	
	# 2. Interpolate the entire transform smoothly
	# Transform3D.interpolate_with handles both position lerp and rotation slerp perfectly
	var weight = lerp_speed * delta
	var next_transform = global_transform.interpolate_with(target_transform, weight)
	
	# 3. Apply the changes based on your toggles
	if copy_position:
		global_position = next_transform.origin
		
	if copy_rotation:
		global_basis = next_transform.basis
	else:
		# If copy_rotation is off, keep the gun's original rotation intact
		global_basis = target_transform.basis

	pass

extends Node3D

@export var mesh_instance_3d: MeshInstance3D
@export var time_to_dissapear := 1.0

var time_left := 0.0
var mat: StandardMaterial3D

func _ready() -> void:
	time_left = time_to_dissapear
	
	if mesh_instance_3d and mesh_instance_3d.get_active_material(0):
		mat = mesh_instance_3d.get_active_material(0).duplicate() as StandardMaterial3D
		
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mesh_instance_3d.material_override = mat


func _process(delta: float) -> void:
	if not mat or time_to_dissapear <= 0.0:
		return

	time_left -= delta
	var alpha_val = clampf(time_left / time_to_dissapear, 0.0, 1.0)
	
	mat.albedo_color.a = alpha_val
	
	if time_left <= 0.0:
		queue_free()

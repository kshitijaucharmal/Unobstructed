extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# if not already in group
	if get_parent():
		get_parent().add_to_group("Swappable")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

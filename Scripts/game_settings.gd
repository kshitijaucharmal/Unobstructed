extends Node3D
class_name GameSettings

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Globals.mouse_captured = true
	Dialogic.timeline_ended.connect(_on_timeline_end)
	pass # Replace with function body.

func start_timeline(timeline_name: String):
	Dialogic.start(timeline_name)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	Globals.mouse_captured = false

func _on_timeline_end():
	Dialogic.timeline_ended.disconnect(_on_timeline_end)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Globals.mouse_captured = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("escape"):
		Globals.mouse_captured = !Globals.mouse_captured
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Globals.mouse_captured else Input.MOUSE_MODE_VISIBLE
		pass
	pass

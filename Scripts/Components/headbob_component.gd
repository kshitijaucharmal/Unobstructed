class_name HeadbobComponent
extends Node3D

@export var automatic = false
@export var target: Node3D

@export var head_bob_amplitude: float = 0.2
@export var head_bob_frequency: float = 0.2

@export var lerp_speed = 10.0

var head_bobbing_vector = Vector2.ZERO
var head_bobbing_index = 0.0

var orig_pos = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	orig_pos = target.position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if automatic:
		headbob(10.0, delta)
	pass
	
func headbob(speed: float, delta: float):
	head_bobbing_index += speed * delta
	
	head_bobbing_vector.y = sin(head_bobbing_index)
	head_bobbing_vector.x = sin(head_bobbing_index/2)
	
	target.position.y = lerp(target.position.y, orig_pos.y + head_bobbing_vector.y*(head_bob_amplitude/2.0),delta * lerp_speed)
	target.position.x = lerp(target.position.x, orig_pos.x + head_bobbing_vector.x*head_bob_amplitude,delta * lerp_speed)
	pass
	
func resetheadposition(delta:float):
	target.position.y = lerp(target.position.y, orig_pos.y, delta * lerp_speed)
	target.position.x = lerp(target.position.x, orig_pos.x, delta * lerp_speed)
	pass

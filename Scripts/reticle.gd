extends BoxContainer

@export var dot_radius := 1.0
@export var dot_color:= Color.WHITE

@export var reticle_lines: Array[Line2D]
@export var player_controller: Player
@export var reticle_speed := 0.25
@export var reticle_distance := 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	adjust_reticle_lines()
	pass

func _draw() -> void:
	draw_circle(Vector2.ZERO, dot_radius, dot_color)

func adjust_reticle_lines():
	var vel = player_controller.get_real_velocity()
	var origin = Vector3.ZERO
	var pos = Vector2.ZERO
	var speed = origin.distance_to(vel)
	
	reticle_lines[0].position = lerp(reticle_lines[0].position, pos + Vector2(0, -speed * reticle_distance), reticle_speed)
	reticle_lines[1].position = lerp(reticle_lines[1].position, pos + Vector2(speed * reticle_distance, 0), reticle_speed)
	reticle_lines[2].position = lerp(reticle_lines[2].position, pos + Vector2(0, speed * reticle_distance), reticle_speed)
	reticle_lines[3].position = lerp(reticle_lines[3].position, pos + Vector2(-speed * reticle_distance, 0), reticle_speed)

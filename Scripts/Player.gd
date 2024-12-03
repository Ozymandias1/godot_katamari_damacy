extends RigidBody3D

@export var camera_node: Camera3D
@export var move_force: float = 200.0

var player_input: Vector2 = Vector2.ZERO

## process
func _process(delta: float) -> void:
	# To handle physical movement, store player input values in _process,
	# and perform the actual processing in _physics_process.
	player_input.x = Input.get_axis("Left", "Right")
	player_input.y = Input.get_axis("Backward", "Forward")	

## physics process
func _physics_process(delta: float) -> void:
	var forward_dir: Vector3 = _get_projected_camera_forward()
	var right_dir: Vector3 = _get_camera_right()
	
	# Calculate the force to be applied to the ball based on player input.
	var vertical_force: Vector3 = forward_dir * player_input.y * move_force * delta
	var horizontal_force: Vector3 = right_dir * player_input.x * move_force * delta
	
	apply_central_force(vertical_force)
	apply_central_force(horizontal_force)

## get the forward vector of the camera projected onto a plane facing upward.
func _get_projected_camera_forward() -> Vector3:
	var camera_forward: Vector3 = -camera_node.global_basis.z
	var plane: Plane = Plane.PLANE_XZ
	# Since the magnitude of the projected vector may not be 1 depending on the camera's angle,
	# normalize it to ensure its magnitude is 1 before performing calculations.
	camera_forward = (plane.project(camera_forward) * 100.0).normalized()
	return camera_forward

## get the right vector of the camera
func _get_camera_right() -> Vector3:
	return camera_node.global_basis.x

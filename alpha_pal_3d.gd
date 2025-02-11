extends CharacterBody3D

@export var movement_speed: float = 1.0
@export var wander_radius: float = 4.0
@export var velocity_smoothing: float = 0.05  # Lower values produce slower acceleration.
@export var rotation_smoothing: float = 0.05  # Adjust this to control turning speed.

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
	_set_random_target()

func _physics_process(_delta: float) -> void:
	# Ensure the navigation map has been synchronized.
	var nav_map = navigation_agent_3d.get_navigation_map()
	if NavigationServer3D.map_get_iteration_id(nav_map) == 0:
		# Navigation map not ready yet – skip processing this frame.
		return
	
	# When we have reached the current target, choose a new random target.
	if navigation_agent_3d.is_target_reached():
		_set_random_target()
	
	# Get the next waypoint from the navigation agent.
	var destination: Vector3 = navigation_agent_3d.get_next_path_position()
	
	# Calculate the desired direction and velocity.
	var desired_direction: Vector3 = (destination - global_position).normalized()
	var desired_velocity: Vector3 = desired_direction * movement_speed
	
	# Smoothly interpolate the current velocity toward the desired velocity.
	velocity = velocity.lerp(desired_velocity, velocity_smoothing)
	
	# Smoothly rotate the NPC to face its movement direction.
	if velocity.length() > 0.1:
		var target_basis: Basis = Basis.looking_at(velocity, Vector3.UP)
		global_transform.basis = global_transform.basis.slerp(target_basis, rotation_smoothing)
	
	# Move the NPC using the updated velocity.
	move_and_slide()

func _set_random_target() -> void:
	# Generate a random target position within the wander radius.
	var random_position: Vector3 = Vector3.ZERO
	random_position.x = randf_range(-wander_radius, wander_radius)
	random_position.z = randf_range(-wander_radius, wander_radius)
	# Optionally, keep the current Y-level.
	random_position.y = global_position.y
	
	# Set the new destination for the navigation agent.
	navigation_agent_3d.set_target_position(random_position)

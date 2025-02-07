extends TextureButton

# Preload your Ball scene.
var BallScene: PackedScene = preload("res://Ball.tscn")

func _pressed() -> void:
	# Instance the ball.
	var ball = BallScene.instantiate()
	
	# Set a random spawn position using the local transform (since the ball isn't in the tree yet).
	var x = randf_range(-5.0, 5.0)
	var y = 5.0  # Spawn height so it falls under gravity.
	var z = randf_range(-5.0, 5.0)
	# Modify the ball's transform rather than its global_transform.
	var new_transform = ball.transform
	new_transform.origin = Vector3(x, y, z)
	ball.transform = new_transform

	# Generate a random color.
	var random_color = Color(randf(), randf(), randf(), 1.0)
	# Assume the MeshInstance3D is a direct child of the Ball node named "MeshInstance3D".
	var mesh_instance = ball.get_node_or_null("MeshInstance3D")
	if mesh_instance:
		var material = StandardMaterial3D.new()
		material.albedo_color = random_color
		mesh_instance.material_override = material

	# Try to add the ball to a node named "NavigationRegion3D".
	var room = get_tree().current_scene.get_node_or_null("NavigationRegion3D")
	if room:
		room.add_child(ball)
	else:
		# If "NavigationRegion3D" isn't found, add it directly to the current scene.
		get_tree().current_scene.add_child(ball)

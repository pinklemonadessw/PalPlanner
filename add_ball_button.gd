extends TextureButton

# Preload your Ball scene.
var BallScene: PackedScene = preload("res://Ball.tscn")

func _pressed() -> void:
	# Instance the ball.
	var ball = BallScene.instantiate()
	
	# Set a random spawn position.
	var x = randf_range(-5.0, 5.0)
	var y = 5.0  # Spawn high so the ball falls under gravity.
	var z = randf_range(-5.0, 5.0)
	# Set the ball's transform locally, since it isn't in the scene tree yet.
	var new_transform = ball.transform
	new_transform.origin = Vector3(x, y, z)
	ball.transform = new_transform

	# Define the only allowed colors: red, green, blue, and yellow.
	var allowed_colors: Array = [
		Color(1, 0, 0, 1),   # Red
		Color(0, 1, 0, 1),   # Green
		Color(0, 0, 1, 1),   # Blue
		Color(1, 1, 0, 1)    # Yellow
	]
	# Pick one at random.
	var random_color: Color = allowed_colors[randi() % allowed_colors.size()]
	
	# Assign the random color to the ball's material.
	var mesh_instance = ball.get_node_or_null("MeshInstance3D")
	if mesh_instance:
		var material = StandardMaterial3D.new()
		material.albedo_color = random_color
		mesh_instance.material_override = material

	# Add the ball to the scene.
	# Optionally, you might add it to a specific node like "NavigationRegion3D".
	var room = get_tree().current_scene.get_node_or_null("NavigationRegion3D")
	if room:
		room.add_child(ball)
	else:
		get_tree().current_scene.add_child(ball)

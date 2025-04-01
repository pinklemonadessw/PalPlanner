extends CanvasLayer

var calendar_expanded = false
var hidden_y = 0

@onready var calendar_panel = $CalendarPanel
@onready var calendar_button = $CalendarButton

func _ready():
	# Calculate the off-screen Y position using the viewport's visible rectangle (Godot 4.3.stable)
	hidden_y = get_viewport().get_visible_rect().size.y
	# Position the panel off-screen and hide it
	calendar_panel.position.y = hidden_y
	calendar_panel.visible = false
	# Set the initial button text to "^"
	calendar_button.text = "^"
	# Connect the button's pressed signal using Godot 4.3.stable syntax
	calendar_button.pressed.connect(_on_CalendarButton_pressed)

func _on_CalendarButton_pressed():
	if not calendar_expanded:
		# Show the panel and animate it into view (target y = 0)
		calendar_panel.visible = true
		var tween = create_tween()
		tween.tween_property(calendar_panel, "position:y", 0, 0.5)
		# When the tween completes, call on_expand_complete()
		tween.tween_callback(Callable(self, "on_expand_complete"))
	else:
		# Animate the panel out (back to hidden_y)
		var tween = create_tween()
		tween.tween_property(calendar_panel, "position:y", hidden_y, 0.5)
		# When the tween completes, call on_retract_complete()
		tween.tween_callback(Callable(self, "on_retract_complete"))

func on_expand_complete():
	# Update the button text and state once expanded
	calendar_button.text = "X"
	calendar_expanded = true

func on_retract_complete():
	# Hide the panel and revert the button text and state once retracted
	calendar_panel.visible = false
	calendar_button.text = "^"
	calendar_expanded = false

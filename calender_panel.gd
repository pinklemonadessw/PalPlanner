extends Panel

@onready var vbox: VBoxContainer = $VBoxContainer
@onready var grid: GridContainer = $VBoxContainer/GridContainer
@onready var add_task_button: Button = $VBoxContainer/AddTaskButton
@onready var month_label: Label = $VBoxContainer/MonthLabel

var current_year: int
var current_month: int
var current_day: int

func _ready() -> void:
	# Get current date.
	var dt: Dictionary = Time.get_datetime_dict_from_system(false)
	current_year = dt["year"]
	current_month = dt["month"]
	current_day = dt["day"]
	
	month_label.text = "Month: " + str(current_month) + " " + str(current_year)
	generate_calendar()
	
	# Initially hide the Add Task button.
	add_task_button.visible = false
	# Connect the button's pressed signal using a Callable.
	add_task_button.pressed.connect(Callable(self, "_on_add_task_button_pressed"))

func generate_calendar() -> void:
	# Remove previous day buttons.
	for child in grid.get_children():
		child.queue_free()
	
	# Determine the weekday for the first day and total days in the month.
	var first_day_weekday = get_first_day_weekday(current_year, current_month)
	var days_in_month = get_days_in_month(current_year, current_month)
	
	# Add empty controls for days before the first day.
	for i in range(first_day_weekday):
		var empty = Control.new()
		grid.add_child(empty)
	
	# Create a button for each day.
	for day in range(1, days_in_month + 1):
		var day_button = Button.new()
		day_button.text = str(day)
		day_button.name = str(day)
		
		# Highlight today’s date.
		if day == current_day:
			day_button.add_theme_color_override("font_color", Color(1, 0, 0))
		
		# Connect the pressed signal using a Callable and bind the day value.
		day_button.pressed.connect(Callable(self, "_on_day_selected"), [day])
		grid.add_child(day_button)

# Returns the weekday (0 = Sunday) for the first day of the given month.
func get_first_day_weekday(year: int, month: int) -> int:
	var a = floor((14 - month) / 12)
	var y = year - a
	var m = month + 12 * a - 2
	var d = (1 + y + floor(y / 4) - floor(y / 100) + floor(y / 400) + floor(31 * m / 12)) % 7
	return int(d)

# Returns the number of days in the month.
func get_days_in_month(year: int, month: int) -> int:
	match month:
		1, 3, 5, 7, 8, 10, 12:
			return 31
		4, 6, 9, 11:
			return 30
		2:
			if ((year % 4 == 0 and year % 100 != 0) or (year % 400 == 0)):
				return 29
			else:
				return 28
		_:
			return 30

# Called when a day button is pressed. 'day' is passed as an extra argument.
func _on_day_selected(day: int) -> void:
	print("Day selected: ", day)
	add_task_button.visible = true
	add_task_button.text = "Add Task for " + str(current_month) + "/" + str(day) + "/" + str(current_year)

func _on_add_task_button_pressed() -> void:
	# Implement your task-adding logic here.
	print("Adding task for selected date.")

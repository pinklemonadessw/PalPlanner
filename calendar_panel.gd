extends Panel

var current_year: int
var current_month: int

@onready var header_label: Label = $Header/MonthLabel
@onready var prev_button: Button = $Header/PrevButton
@onready var next_button: Button = $Header/NextButton
@onready var grid_container: GridContainer = $GridContainer
@onready var weekday_container: HBoxContainer = $WeekdayContainer

func _ready():
	# Get today's date from the system (per Godot 4.3.stable documentation)
	var date_dict = Time.get_datetime_dict_from_system()
	current_year = date_dict.year
	current_month = date_dict.month
	
	# Connect the previous and next buttons using Godot 4.3 signal connection syntax
	prev_button.pressed.connect(_on_prev_button_pressed)
	next_button.pressed.connect(_on_next_button_pressed)
	
	# Populate the calendar grid
	update_calendar()
	add_weekday_labels()
	

func add_weekday_labels():
	#Weekday names starting on Sunday
	var weekdays: Array[String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
	
	#Clear existing children
	for child in weekday_container.get_children():
		child.queue_free()
	
	#Create label for each weekday and add it
	for day in weekdays:
		var day_label = Label.new()
		day_label.text = day
		# Center the text
		day_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		weekday_container.add_child(day_label)

func update_calendar():
	# Update header to display current month and year
	header_label.text = get_month_name(current_month) + " " + str(current_year)
	
	# Clear any existing children from the grid container
	for child in grid_container.get_children():
		grid_container.remove_child(child)
		child.queue_free()
	
	# Calculate the weekday (0 = Monday, 6 = Sunday) for the 1st day of the current month
	var first_weekday = get_weekday(current_year, current_month, 1)
	
	# Add blank placeholders so that the first day falls on the correct weekday
	for i in range(first_weekday):
		var blank = Control.new()
		grid_container.add_child(blank)
	
	# Create a day button for each day in the month
	var days_in_month = get_days_in_month(current_year, current_month)
	for day in range(1, days_in_month + 1):
		var day_button = Button.new()
		day_button.text = str(day)
		day_button.name = str(day)
		# Connect the pressed signal, binding the day as an extra parameter
		day_button.pressed.connect(Callable(self, "_on_day_button_pressed").bind(day))
		grid_container.add_child(day_button)

# Returns the weekday index for a given date using Zeller's Congruence.
# The formula yields: 0 = Monday, 1 = Tuesday, …, 6 = Sunday.
func get_weekday(year: int, month: int, day: int) -> int:
	var y = year
	var m = month
	if m < 3:
		m += 12
		y -= 1
	var K = y % 100
	var J = int(y / 100)
	var h = (day + int((13 * (m + 1)) / 5) + K + int(K / 4) + int(J / 4) + 5 * J) % 7
	# Convert Zeller's result (0 = Saturday, 1 = Sunday, 2 = Monday, …) so that Monday becomes 0:
	return (h + 5) % 7

# Returns the number of days in a given month of a given year.
func get_days_in_month(year: int, month: int) -> int:
	if month == 2:
		return 29 if is_leap_year(year) else 28
	elif month in [4, 6, 9, 11]:
		return 30
	else:
		return 31

# Determines if a year is a leap year.
func is_leap_year(year: int) -> bool:
	return (year % 400 == 0) or ((year % 4 == 0) and (year % 100 != 0))

# Returns the full month name (e.g., "January") for a month number.
func get_month_name(month: int) -> String:
	var month_names = [
		"January", "February", "March", "April", "May", "June",
		"July", "August", "September", "October", "November", "December"
	]
	return month_names[month - 1]

# Called when the previous button is pressed.
func _on_prev_button_pressed():
	current_month -= 1
	if current_month < 1:
		current_month = 12
		current_year -= 1
	update_calendar()

# Called when the next button is pressed.
func _on_next_button_pressed():
	current_month += 1
	if current_month > 12:
		current_month = 1
		current_year += 1
	update_calendar()

# Called when a day button is pressed; 'day' is the day number.
func _on_day_button_pressed(day: int):
	print("Day selected: ", day)
	# Here you can load or display tasks for the selected day.

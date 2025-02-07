extends Label

func _ready() -> void:
	# Create a Timer that fires every second.
	var timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	
	# Connect the timer's timeout signal to the _update_time function.
	timer.timeout.connect(_update_time)
	
	# Do an initial update.
	_update_time()

func _update_time() -> void:
	# Retrieve the current date and time as a dictionary (local time).
	var dt: Dictionary = Time.get_datetime_dict_from_system(false)
	
	# Arrays to map numeric weekday and month to names.
	var weekday_names = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
	var month_names   = ["Jan.", "Feb.", "Mar.", "Apr.", "May", "Jun.", "Jul.", "Aug.", "Sep.", "Oct.", "Nov.", "Dec."]
	
	# Format the date string, e.g., "Friday Feb. 7, 2025"
	var weekday = weekday_names[ dt["weekday"] % weekday_names.size() ]
	var month   = month_names[ dt["month"] - 1 ]
	var date_text = "%s %s %d, %d" % [weekday, month, dt["day"], dt["year"]]
	
	# Convert 24-hour format to 12-hour format with AM/PM.
	var hour = dt["hour"]
	var ampm = "AM"
	if hour >= 12:
		ampm = "PM"
		if hour > 12:
			hour -= 12
	if hour == 0:
		hour = 12  # Correct for midnight.
	
	# Format the time string, e.g., "3:55:07 PM"
	var time_text = "%d:%02d:%02d %s" % [hour, dt["minute"], dt["second"], ampm]
	
	# Update the label's text to show the full date and time.
	text = date_text + "\n" + time_text

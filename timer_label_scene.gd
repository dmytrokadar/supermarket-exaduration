extends Label

var time_passed = 0.0

func _process(delta):
	time_passed += delta
	
	var hours = int(time_passed) / 3600
	
	var mins = (int(time_passed) / 60) % 60
	

	var secs = int(time_passed) % 60
	
	
	var msecs = int(fmod(time_passed, 1) * 100)
   
	#HH:MM:SS:MsMs
	text = "%02d:%02d:%02d.%02d" % [hours, mins, secs, msecs]

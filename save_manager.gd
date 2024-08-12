extends Node

const SAVEFILE = "user://data.save"

var data: Dictionary = {}

func _ready() -> void:
	load_data()

func load_data() -> void:
	if not FileAccess.file_exists(SAVEFILE):
		print("Data save file not found, data not loaded")
		return
	
	var save_file = FileAccess.open(SAVEFILE, FileAccess.READ)
	var json_content = save_file.get_as_text()
	save_file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_content)
	if not parse_result == OK:
			print("Encountered JSON Parse Error while loading: ", json.get_error_message())
			return
			
	data = json.get_data()
	print("Successfully loaded data:")
	print(data)

func save_data() -> void:
	var save_file = FileAccess.open(SAVEFILE, FileAccess.WRITE)
	var json_content = JSON.stringify(data)
	save_file.store_string(json_content)
	save_file.close()
	print("Successfully saved data")


func get_level_data(level: String) -> float:
	if data.has(level):
		return data[level]
	else:
		return -1.0


func update_level_data(level: String, time: float) -> void:
	if not data.has(level):
		print("Saving new level completion time of ", time, "...")
		data[level] = time
		save_data()
		return
	
	if data[level] > time:
		print("Congratulations, you've beat your previous best time!")
		print("Saving new best time of ", time, "...")
		data[level] = time
		save_data()

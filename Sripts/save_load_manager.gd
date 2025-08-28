extends Node

class_name SaveLoadManager

static var Instance : SaveLoadManager

func _ready() -> void:
	Instance = self

static func GetInstance() -> SaveLoadManager:
	return Instance

func SaveSample(Sample : AudioStream, Name : String) -> void:
	var file : SampleListFile
	if (FileAccess.file_exists("user://SampleList.tres")):
		file = load("user://SampleList.tres")
	if (file == null):
		file = SampleListFile.new()
	
	file.List[Name] = Sample
	
	ResourceSaver.save(file, "user://SampleList.tres")

func LoadSamples() -> Dictionary[String, AudioStream]:
	if (!FileAccess.file_exists("user://SampleList.tres")):
		print("Couldn't find save file, skipping loading")
		return {}
	var file = load("user://SampleList.tres") as SampleListFile
	
	if (file == null):
		return {}
		
	return file.List

func ClearSamples() -> void:
	if (!FileAccess.file_exists("user://SampleList.tres")):
		print("Couldn't find save file")
		return
	else:
		DirAccess.remove_absolute("user://SampleList.tres")
	

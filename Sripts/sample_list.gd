extends PanelContainer

class_name SampleList

@export var ButtonParent : Control
@export var FileDialogue : FileDialog

signal OnSampleLoaded(Sample : AudioStream)
signal OnSampleSelected(Sample : AudioStream)
signal OnSamplesCleared()

func SetSamples(Samples : Dictionary[String, AudioStream]) -> void:
	for g in Samples.keys():
		var b = Button.new()
		b.text = g
		b.pressed.connect(SampleSelected.bind(Samples[g]))
		ButtonParent.add_child(b)

func SampleSelected(Sample : AudioStream) -> void:
	for g in ButtonParent.get_children():
		if (g is Button):
			g.queue_free()
	OnSampleSelected.emit(Sample)


func _on_load_pressed() -> void:
	FileDialogue.popup()
	print("Staring Loading")


func load_mp3(path : String):
	print("Loading sound file {0}".format([path]))
	var file = FileAccess.open(path, FileAccess.READ)
	var sound
	if (path.substr(path.length() - 3, path.length()) == "mp3"):
		sound = AudioStreamMP3.new()
	else:
		sound = AudioStreamWAV.new()
	sound.data = file.get_buffer(file.get_length())
	return sound

func _on_file_dialog_file_selected(path: String) -> void:
	print("trying to load {0}".format([path]))
	var file = load_mp3(path)
	if (file is AudioStream):
		OnSampleLoaded.emit(file, path.get_file())
		print("Loaded : {0}".format([path.get_file()]))
		SampleSelected(file)


func _on_clear_pressed() -> void:
	for g in ButtonParent.get_children():
		if (g is Button):
			g.queue_free()
	OnSamplesCleared.emit()
	

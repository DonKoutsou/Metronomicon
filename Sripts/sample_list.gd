extends PanelContainer

class_name SampleList

@export var ButtonParent : Control

signal OnSampleSelected(Sample : AudioStream)

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

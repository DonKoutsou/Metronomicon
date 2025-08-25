extends VBoxContainer

class_name Bar

@export_group("Settings")
@export var StartingClicksPerBeat : int = 4

@export_group("Scenes")
@export_file() var BeatPanel : String

@export_group("Nodes")
@export var ClickLabel : Label
@export var BARUI : ProgressBar
@export var BeatPanelParent : Control
@export var ClickSound : AudioStreamPlayer
@export var BarSound : AudioStreamPlayer
@export var TimeLabel : Label

signal RemoveSelf

var CurrentBarLeangth : float
var CurrentClicksPerBeat : int
var CurrentClickLeangth : float
var CurrentClick : int = 0
var Interval : float
var ClickInterval : float
var T : int = 1

func _ready() -> void:
	CurrentClicksPerBeat = StartingClicksPerBeat
	OnClicksPerBeatChanged()

func Update(delta : float) -> bool:
	
	if (ClickInterval > CurrentClickLeangth):
		ClickInterval -= CurrentClickLeangth
		CurrentClick += 1
		if (CurrentClick == CurrentClicksPerBeat):
			BarSound.play()
		else:
			ClickSound.play()
		
	if (Interval > CurrentBarLeangth):
		Interval -= CurrentBarLeangth
		ClickInterval = Interval
		CurrentClick = 0
		return true
	
	BARUI.value = Interval
	
	Interval += delta * T
	ClickInterval += delta * T
	
	return false

func OnBPMChanged(NewBpm : int) -> void:
	Reset()

	var BarLeangth = 60.0 / NewBpm
	BARUI.max_value = BarLeangth
	
	CurrentBarLeangth = (60.0 / NewBpm)
	CurrentClickLeangth = CurrentBarLeangth / CurrentClicksPerBeat


func OnClicksPerBeatChanged() -> void:
	Reset()
	
	CurrentClickLeangth = CurrentBarLeangth / CurrentClicksPerBeat
	
	ClickLabel.text = "CLICKS : {0}".format([CurrentClicksPerBeat])
	
	for g in BeatPanelParent.get_children():
		g.queue_free()
		
	for g in CurrentClicksPerBeat:
		var Pan = load(BeatPanel).instantiate()
		BeatPanelParent.add_child(Pan)


func Reset() -> void:
	Interval = 0
	ClickInterval = 0
	CurrentClick = 0


func _on_decrease_clicks_pressed() -> void:
	CurrentClicksPerBeat = max(1, CurrentClicksPerBeat - 1)
	OnClicksPerBeatChanged()


func _on_increace_clicks_pressed() -> void:
	CurrentClicksPerBeat += 1
	OnClicksPerBeatChanged()


func _on_button_pressed() -> void:
	RemoveSelf.emit()


func _on_lower_time_pressed() -> void:
	T = max(1, T - 1)
	TimeLabel.text = "TIME : {0}".format([T])

func _on_increace_time_pressed() -> void:
	T += 1
	TimeLabel.text = "TIME : {0}".format([T])
	

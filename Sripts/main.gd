extends Control

class_name Main

@export_group("Settings")
@export var StartingBPM : int = 45
@export var StartingClicksPerBeat : int = 4


@export_group("Nodes")
@export var BPMLabel : Label
@export var ClickLabel : Label
@export var BARUI : ProgressBar
@export var ClickSound : AudioStreamPlayer
@export var BarSound : AudioStreamPlayer
@export var BeatPanelParent : Control


@export_group("Scenes")
@export_file() var BeatPanel : String


var CurrentBPM : int
var CurrentBarLeangth : float
var CurrentClicksPerBeat : int
var CurrentClickLeangth : float
var CurrentClick : int = 0
var Interval : float
var ClickInterval : float
var Paused : bool = false


func _ready() -> void:
	CurrentBPM = StartingBPM
	CurrentClicksPerBeat = StartingClicksPerBeat
	OnBPMChanged()
	OnClicksPerBeatChanged()
	
func _process(delta: float) -> void:
	if (Paused):
		return
		
	Interval += delta
	ClickInterval += delta
	
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
	
	BARUI.value = Interval
	

func _on_increace_bpm_pressed() -> void:
	CurrentBPM += 1
	OnBPMChanged()


func _on_lower_bpm_pressed() -> void:
	CurrentBPM = max(1, CurrentBPM - 1)
	OnBPMChanged()


func OnBPMChanged() -> void:
	Reset()
	
	BPMLabel.text = "BPM : {0}".format([CurrentBPM])
	var BarLeangth = 60.0 / CurrentBPM
	BARUI.max_value = BarLeangth
	
	CurrentBarLeangth = (60.0 / CurrentBPM)
	CurrentClickLeangth = CurrentBarLeangth / CurrentClicksPerBeat


func OnClicksPerBeatChanged() -> void:
	Reset()
	
	CurrentClickLeangth = CurrentBarLeangth / CurrentClicksPerBeat
	
	ClickLabel.text = "Click\nPer Beat\n{0}".format([CurrentClicksPerBeat])
	
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


func _on_pause_pressed() -> void:
	Paused = !Paused

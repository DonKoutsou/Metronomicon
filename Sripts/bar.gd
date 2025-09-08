extends PanelContainer

class_name Bar

@export_group("Settings")
@export var StartingClicksPerBeat : int = 4

@export_group("Scenes")
@export_file() var BeatPanel : String

@export_group("Nodes")
@export var ClickLabel : Label
@export var BARUI : ProgressBar
@export var BeatPanelParent : Control
@export var StartingSample : AudioStream
@export var TimeLabel : Label
@export var SampleNameLabel : Label
@export var SettingsPanel : Control

signal RemoveSelf
signal SampleSwitch

var CurrentSample : AudioStream

var MuttedBeats : Array[int]
var BeatsSpots : Array [BeatSpot]

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
	CurrentSample = StartingSample

func ChangeSample(SampleName : String, Sample : AudioStream) -> void:
	SampleNameLabel.text = SampleName
	CurrentSample = Sample
	#BarSound.stream = Sample

func Update(delta : float) -> bool:
	
	if (ClickInterval > CurrentClickLeangth):
		ClickInterval -= CurrentClickLeangth
		
		if (!MuttedBeats.has(CurrentClick)):
			var pan = BeatsSpots[CurrentClick]
			pan.Bounce()
			
			var sound = DeletableSound.new()
			sound.stream = CurrentSample
			sound.volume_db = -6
			
			if (CurrentClick + 1 == CurrentClicksPerBeat):
				sound.pitch_scale = randf_range(0.79, 0.81)
			else:
				sound.pitch_scale = randf_range(0.99, 1.01)
			
			add_child(sound)
			sound.play()
		
		CurrentClick += 1
		
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
	
	MuttedBeats.clear()
	BeatsSpots.clear()
	
	CurrentClickLeangth = CurrentBarLeangth / CurrentClicksPerBeat
	
	ClickLabel.text = "BEATS PER BAR:{0}".format([CurrentClicksPerBeat])
	
	for g in BeatPanelParent.get_children():
		g.queue_free()
		
	for g in CurrentClicksPerBeat:
		var Pan = load(BeatPanel).instantiate() as Button
		BeatPanelParent.add_child(Pan)
		Pan.pressed.connect(BeatPressed.bind(g))
		BeatsSpots.append(Pan)
		

func BeatPressed(BeatIndex : int) -> void:
	if (MuttedBeats.has(BeatIndex)):
		MuttedBeats.erase(BeatIndex)
		#BeatPanelParent.get_child(BeatIndex).disabled = false
	else:
		MuttedBeats.append(BeatIndex)
		#BeatPanelParent.get_child(BeatIndex).disabled = true

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
	TimeLabel.text = "SPEED : {0}".format([T])

func _on_increace_time_pressed() -> void:
	T += 1
	TimeLabel.text = "SPEED : {0}".format([T])
	

func _on_sample_button_pressed() -> void:
	SampleSwitch.emit()


func _on_button_2_pressed() -> void:
	SettingsPanel.visible = !SettingsPanel.visible

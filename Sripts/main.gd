extends Control

class_name Main

@export_group("Settings")
@export var StartingBPM : int = 45
@export var AvailableSamples : Dictionary[String, AudioStream]

@export_group("Nodes")
@export var BarParent : Control
@export var BPMLabel : Label
@export var PauseButton : Button
@export var SList : SampleList

@export_group("Scenes")
@export_file() var BarScene : String

var CurrentBPM : int

var Bars : Array[Bar]
var CurrentlyProccessedBar : int = 0

var Paused : bool = false

func _ready() -> void:
	CurrentBPM = StartingBPM
	OnBPMChanged()
	
func _physics_process(delta: float) -> void:
	if (Paused or Bars.size() == 0):
		return
	
	var currentBar = Bars[CurrentlyProccessedBar]
	if (currentBar.Update(delta)):
		CurrentlyProccessedBar += 1
		if (CurrentlyProccessedBar >= Bars.size()):
			CurrentlyProccessedBar = 0

func _on_pause_pressed() -> void:
	if (!Paused):
		PauseButton.text = "START"
	else:
		PauseButton.text = "STOP"
	Paused = !Paused


func _on_add_bar_pressed() -> void:
	var NewBar = load(BarScene).instantiate() as Bar
	BarParent.add_child(NewBar)
	Bars.append(NewBar)
	NewBar.RemoveSelf.connect(OnBarRemoved.bind(NewBar))
	NewBar.SampleSwitch.connect(OnSampleSwitchPressed.bind(NewBar))
	NewBar.OnBPMChanged(CurrentBPM)

func OnBarRemoved(B : Bar) -> void:
	B.queue_free()
	Bars.erase(B)
	CurrentlyProccessedBar = 0
	for g in Bars:
		g.Reset()

func OnSampleSwitchPressed(B : Bar) -> void:
	Paused = true
	SList.visible = true
	SList.SetSamples(AvailableSamples)
	var sample = await SList.OnSampleSelected
	B.ChangeSample(AvailableSamples.find_key(sample), sample)
	SList.visible = false
	Paused = false

func _on_increace_bpm_pressed() -> void:
	CurrentBPM += 1
	OnBPMChanged()

func _on_increace_bpm_2_pressed() -> void:
	CurrentBPM += 10
	OnBPMChanged()

func _on_lower_bpm_pressed() -> void:
	CurrentBPM = max(1, CurrentBPM - 1)
	OnBPMChanged()

func _on_lower_bpm_2_pressed() -> void:
	CurrentBPM = max(1, CurrentBPM - 10)
	OnBPMChanged()

func OnBPMChanged() -> void:
	BPMLabel.text = "BPM : {0}".format([CurrentBPM])
	for g in Bars:
		g.OnBPMChanged(CurrentBPM)
		

extends Button

class_name BeatSpot

func _ready() -> void:
	pivot_offset = size / 2

var tw : Tween
var tw2 : Tween

func Bounce() -> void:
	if (is_instance_valid(tw)):
		scale = Vector2(1,1)
		tw.kill()
	
	tw = create_tween()
	tw.set_ease(Tween.EASE_IN)
	tw.set_trans(Tween.TRANS_BACK)
	tw.tween_property(self, "scale", Vector2(1.1,1.1), 0.05)
	tw.finished.connect(BounceOff)

func BounceOff() -> void:
	if (is_instance_valid(tw2)):
		scale = Vector2(1.1,1.1)
		tw2.kill()
		
	tw2 = create_tween()
	tw2.set_ease(Tween.EASE_IN)
	tw2.set_trans(Tween.TRANS_BACK)
	tw2.tween_property(self, "scale", Vector2(1,1), 0.05)

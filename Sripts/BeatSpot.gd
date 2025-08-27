extends Button

class_name BeatSpot

func _ready() -> void:
	pivot_offset = size / 2

func Bounce() -> void:
	var tw = create_tween()
	tw.set_ease(Tween.EASE_IN)
	tw.set_trans(Tween.TRANS_BACK)
	tw.tween_property(self, "scale", Vector2(1.1,1.1), 0.05)
	await tw.finished
	var tw2 = create_tween()
	tw2.set_ease(Tween.EASE_IN)
	tw2.set_trans(Tween.TRANS_BACK)
	tw2.tween_property(self, "scale", Vector2(1,1), 0.05)

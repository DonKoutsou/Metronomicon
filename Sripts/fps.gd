extends Label

func _physics_process(delta: float) -> void:
	text = "FPS : {0}".format([Engine.physics_ticks_per_second])

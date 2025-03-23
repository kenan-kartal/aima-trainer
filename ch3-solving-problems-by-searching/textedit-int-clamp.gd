extends TextEdit

@export var min: int = 0
@export var max: int = 100

func sanitize():
	var i := text.to_int()
	i = clamp(i, min, max)
	text = str(i)

func _init() -> void:
	focus_exited.connect(sanitize)

extends TextEdit

func sanitize():
	var f := text.to_float()
	text = str(f)

func _init() -> void:
	focus_exited.connect(sanitize)

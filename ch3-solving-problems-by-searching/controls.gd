extends Control

@onready var start_button := $HBoxContainer/StartButton
@onready var stop_button  := $HBoxContainer/StopButton

func _ready() -> void:
	start_button.pressed.connect(on_start_pressed)
	stop_button.pressed.connect(on_stop_pressed)
	start_button.disabled = false
	stop_button.disabled = true

func on_start_pressed() -> void:
	start_button.disabled = true
	stop_button.disabled = false

func on_stop_pressed() -> void:
	start_button.disabled = false
	stop_button.disabled = true

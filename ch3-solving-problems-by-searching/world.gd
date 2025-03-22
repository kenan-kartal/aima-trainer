class_name Ch3World

extends Node3D

@onready var maze := $Maze

func _ready() -> void:
	maze.generate(randi())

func _on_back_to_scene_selector_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

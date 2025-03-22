extends Node2D

func _on_ch_2_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ch2-intelligent-agents/house.tscn")

func _on_ch_3_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ch3-solving-problems-by-searching/world.tscn")

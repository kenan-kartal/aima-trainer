extends Control

class OptionsData:
	var seed: int
	var start_row: int
	var start_col: int
	var finish_row: int
	var finish_col: int
	var search_type: int
	var time_step: float

@onready var panel := $PanelContainer
@onready var panel_button := $OptionsButton
@onready var seed := $PanelContainer/VBoxContainer/HBoxContainer3/Seed
@onready var start_row := $PanelContainer/VBoxContainer/HBoxContainer/StartCellRow
@onready var start_col := $PanelContainer/VBoxContainer/HBoxContainer/StartCellCol
@onready var finish_row := $PanelContainer/VBoxContainer/HBoxContainer2/FinishCellRow
@onready var finish_col := $PanelContainer/VBoxContainer/HBoxContainer2/FinishCellCol
@onready var search_type := $PanelContainer/VBoxContainer/SearchTypesList
@onready var time_step := $PanelContainer/VBoxContainer/HBoxContainer4/TimeStep

func _ready() -> void:
	panel_button.pressed.connect(toggle_panel)
	panel.visible = false
	search_type.select(0)

func toggle_panel() -> void:
	panel.visible = !panel.visible

func get_options_data() -> OptionsData:
	start_row.sanitize()
	start_col.sanitize()
	finish_row.sanitize()
	finish_col.sanitize()
	var data = OptionsData.new()
	data.seed = seed.text.to_int()
	data.start_row = start_row.text.to_int()
	data.start_col = start_col.text.to_int()
	data.finish_row = finish_row.text.to_int()
	data.finish_col = finish_col.text.to_int()
	data.search_type = search_type.get_selected_items()[0]
	data.time_step = time_step.text.to_float()
	return data

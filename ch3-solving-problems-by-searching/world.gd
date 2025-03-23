class_name Ch3World

extends Node3D

var is_running := false
var delay_time := 0.5
var curr_delay_time := 0.0
var opts

@onready var maze := $Maze
@onready var options := $Options
@onready var ai := $AI

func _ready() -> void:
	maze.generate(0)

func _process(delta: float) -> void:
	if !is_running:
		return
	curr_delay_time += delay_time
	if curr_delay_time >= delay_time:
		curr_delay_time = 0.0
		if ai.search_step():
			is_running = false

func _on_back_to_scene_selector_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

func _on_start_button_pressed() -> void:
	opts = options.get_options_data()
	if opts.start_row == opts.finish_row && opts.start_col == opts.finish_col:
		return
	maze.generate(opts.seed)
	ai.init_search(
		maze.get_cell(opts.start_row, opts.start_col),
		maze.get_cell(opts.finish_row, opts.finish_col),
		maze
	)
	is_running = true
	curr_delay_time = 0.0
	$Options/PanelContainer.visible = false

func _on_stop_button_pressed() -> void:
	is_running = false

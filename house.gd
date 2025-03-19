extends Node3D

enum State {VacuumUpdate, RoomUpdate, AgentUpdate}

@onready var room_left = $Room_left
@onready var room_right = $Room_right
@onready var vacuum = $Vacuum
@onready var vacuum_controller = $VacuumController
@onready var current_room = room_left

var is_running: bool = false
var state: State = State.VacuumUpdate
var breath_time: float = 0.5
var cur_breath_time: float = 0
var same_room_chance: float = 0.1
var opposite_room_chance: float = 0.5
var move_cost: float = 20
var suck_cost: float = 5
var completed_turns: int = 0
var total_cost: float = 0
var right_dirty_count: int = 0
var left_dirty_count: int = 0
var agent_type: String = "blind"

func _ready() -> void:
	$Controls/AgentTypeLabel/AgentTypeList.select(0)

func _process(delta: float) -> void:
	if (!is_running):
		return
	match state:
		State.VacuumUpdate:
			vacuum.update(delta)
			if (!vacuum.is_in_action()):
				state = State.RoomUpdate
		State.RoomUpdate:
			var left_chance = randf()
			var right_chance = randf()
			if (!room_left.is_dirty()):
				if (current_room == room_left && left_chance <= same_room_chance):
					room_left.spawn_dirt()
				elif (current_room != room_left && left_chance <= opposite_room_chance):
					room_left.spawn_dirt()
			if (!room_right.is_dirty()):
				if (current_room == room_right && right_chance <= same_room_chance):
					room_right.spawn_dirt()
				elif (current_room != room_right && right_chance <= opposite_room_chance):
					room_right.spawn_dirt()
			state = State.AgentUpdate
		State.AgentUpdate:
			if (cur_breath_time < breath_time):
				cur_breath_time += delta
				if (cur_breath_time >= breath_time):
					cur_breath_time = 0
					vacuum_controller.agent_program()
					state = State.VacuumUpdate
					completed_turns += 1
					if (room_left.is_dirty() && (current_room != room_left || !vacuum.wants_to_suck)):
						left_dirty_count += 1
						$Performance/LeftDirtyLabel.text = "Left Dirty For: %d" % left_dirty_count
					if (room_right.is_dirty() && (current_room != room_right || !vacuum.wants_to_suck)):
						right_dirty_count += 1
						$Performance/RightDirtyLabel.text = "Right Dirty For: %d" % right_dirty_count
					$Performance/TurnLabel.text = "Turns Completed: %d" % completed_turns

func _on_vacuum_moved_left() -> void:
	current_room = room_left
	state = State.RoomUpdate

func _on_vacuum_moved_right() -> void:
	current_room = room_right
	state = State.RoomUpdate

func _on_vacuum_sucked() -> void:
	current_room.remove_dirt()
	state = State.RoomUpdate

func _on_vacuum_controller_act_move_left() -> void:
	vacuum.move_left()
	total_cost += move_cost
	$Performance/CostLabel.text = "Total Cost: %.2f" % total_cost

func _on_vacuum_controller_act_move_right() -> void:
	vacuum.move_right()
	total_cost += move_cost
	$Performance/CostLabel.text = "Total Cost: %.2f" % total_cost

func _on_vacuum_controller_act_suck() -> void:
	vacuum.suck()
	current_room.animate_cleaning()
	total_cost += suck_cost
	$Performance/CostLabel.text = "Total Cost: %.2f" % total_cost

func _on_vacuum_controller_perceive_environment() -> void:
	if (current_room == room_left):
		vacuum_controller.room_position = "left"
	else:
		vacuum_controller.room_position = "right"
	vacuum_controller.room_is_dirty = current_room.is_dirty()

func _on_start_button_pressed() -> void:
	$Controls/StartButton.disabled = true
	$Controls/StopButton.disabled = false
	start()

func _on_stop_button_pressed() -> void:
	$Controls/StartButton.disabled = false
	$Controls/StopButton.disabled = true
	stop()

func _on_agent_type_list_item_selected(index: int) -> void:
	match index:
		1:
			agent_type = "reflex"
		2:
			agent_type = "table"
		_:
			agent_type = "blind"

func start():
	is_running = true
	state = State.VacuumUpdate
	current_room = room_left
	cur_breath_time = 0
	same_room_chance = $Controls/SameLabel/SameSlider.value
	opposite_room_chance = $Controls/OppLabel/OppSlider.value
	move_cost = float($Controls/MoveCostLabel/MoveCostEdit.text)
	suck_cost = float($Controls/SuckCostLabel/SuckCostEdit.text)
	completed_turns = 0
	total_cost = 0
	right_dirty_count = 0
	left_dirty_count = 0
	vacuum.reset()
	vacuum_controller.reset()
	vacuum_controller.set_agent_type(agent_type)
	room_left.reset()
	room_right.reset()
	seed($Controls/SeedLabel/SeedEdit.text.hash())
	$Performance/LeftDirtyLabel.text = "Left Dirty For: %d" % left_dirty_count
	$Performance/RightDirtyLabel.text = "Right Dirty For: %d" % right_dirty_count
	$Performance/TurnLabel.text = "Turns Completed: %d" % completed_turns
	$Performance/CostLabel.text = "Total Cost: %.2f" % total_cost

func stop():
	is_running = false

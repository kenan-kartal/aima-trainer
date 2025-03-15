extends Node

signal perceive_environment
signal act_move_right
signal act_move_left
signal act_suck

### Updated by perceive()
### Updates the perception for the current room
var room_position: String # "left" or "right"
var room_is_dirty: bool
###

### Blind agent
var guessed_room_position: String = "left"
var cleaned_current: bool = false
###

### Table Driven Agent
class Percept:
	var room_position: String
	var room_is_dirty: bool

func get_percept(pos, is_dirty) -> Percept:
	var percept = Percept.new()
	percept.room_position = pos
	percept.room_is_dirty = is_dirty
	return percept

var percept_sequence: Array[Percept] = []
var percept_sequence_max_size: int = 3
var table = {
	[get_percept("left", false)]: "right",
	[get_percept("left", false), get_percept("left", false)]: "right",
	[get_percept("left", false), get_percept("left", false), get_percept("left", false)]: "right",
	[get_percept("left", false), get_percept("left", false), get_percept("left", true)]: "suck",
	[get_percept("left", false), get_percept("left", false), get_percept("right", false)]: "wait",
	[get_percept("left", false), get_percept("left", false), get_percept("right", true)]: "suck",
	[get_percept("left", false), get_percept("left", true)]: "suck",
	[get_percept("left", false), get_percept("left", true), get_percept("left", false)]: "right",
	[get_percept("left", false), get_percept("left", true), get_percept("left", true)]: "suck",
	[get_percept("left", false), get_percept("left", true), get_percept("right", false)]: "left",
	[get_percept("left", false), get_percept("left", true), get_percept("right", true)]: "suck",
	[get_percept("left", false), get_percept("right", false)]: "wait",
	[get_percept("left", false), get_percept("right", false), get_percept("left", false)]: "wait",
	[get_percept("left", false), get_percept("right", false), get_percept("left", true)]: "suck",
	[get_percept("left", false), get_percept("right", false), get_percept("right", false)]: "left",
	[get_percept("left", false), get_percept("right", false), get_percept("right", true)]: "suck",
	[get_percept("left", false), get_percept("right", true)]: "suck",
	[get_percept("left", false), get_percept("right", true), get_percept("left", false)]: "right",
	[get_percept("left", false), get_percept("right", true), get_percept("left", true)]: "suck",
	[get_percept("left", false), get_percept("right", true), get_percept("right", false)]: "wait",
	[get_percept("left", false), get_percept("right", true), get_percept("right", true)]: "suck",
	[get_percept("left", true)]: "suck",
	[get_percept("left", true), get_percept("left", false)]: "wait",
	[get_percept("left", true), get_percept("left", false), get_percept("left", false)]: "right",
	[get_percept("left", true), get_percept("left", false), get_percept("left", true)]: "suck",
	[get_percept("left", true), get_percept("left", false), get_percept("right", false)]: "wait",
	[get_percept("left", true), get_percept("left", false), get_percept("right", true)]: "suck",
	[get_percept("left", true), get_percept("left", true)]: "suck",
	[get_percept("left", true), get_percept("left", true), get_percept("left", false)]: "wait",
	[get_percept("left", true), get_percept("left", true), get_percept("left", true)]: "suck",
	[get_percept("left", true), get_percept("left", true), get_percept("right", false)]: "left",
	[get_percept("left", true), get_percept("left", true), get_percept("right", true)]: "suck",
	[get_percept("left", true), get_percept("right", false)]: "left",
	[get_percept("left", true), get_percept("right", false), get_percept("left", false)]: "wait",
	[get_percept("left", true), get_percept("right", false), get_percept("left", true)]: "suck",
	[get_percept("left", true), get_percept("right", false), get_percept("right", false)]: "left",
	[get_percept("left", true), get_percept("right", false), get_percept("right", true)]: "suck",
	[get_percept("left", true), get_percept("right", true)]: "suck",
	[get_percept("left", true), get_percept("right", true), get_percept("left", false)]: "right",
	[get_percept("left", true), get_percept("right", true), get_percept("left", true)]: "suck",
	[get_percept("left", true), get_percept("right", true), get_percept("right", false)]: "left",
	[get_percept("left", true), get_percept("right", true), get_percept("right", true)]: "suck",
	[get_percept("right", false)]: "left",
	[get_percept("right", false), get_percept("left", false)]: "wait",
	[get_percept("right", false), get_percept("left", false), get_percept("left", false)]: "right",
	[get_percept("right", false), get_percept("left", false), get_percept("left", true)]: "suck",
	[get_percept("right", false), get_percept("left", false), get_percept("right", false)]: "wait",
	[get_percept("right", false), get_percept("left", false), get_percept("right", true)]: "suck",
	[get_percept("right", false), get_percept("left", true)]: "suck",
	[get_percept("right", false), get_percept("left", true), get_percept("left", false)]: "wait",
	[get_percept("right", false), get_percept("left", true), get_percept("left", true)]: "suck",
	[get_percept("right", false), get_percept("left", true), get_percept("right", false)]: "left",
	[get_percept("right", false), get_percept("left", true), get_percept("right", true)]: "suck",
	[get_percept("right", false), get_percept("right", false)]: "wait",
	[get_percept("right", false), get_percept("right", false), get_percept("left", false)]: "right",
	[get_percept("right", false), get_percept("right", false), get_percept("left", true)]: "suck",
	[get_percept("right", false), get_percept("right", false), get_percept("right", false)]: "left",
	[get_percept("right", false), get_percept("right", false), get_percept("right", true)]: "suck",
	[get_percept("right", false), get_percept("right", true)]: "suck",
	[get_percept("right", false), get_percept("right", true), get_percept("left", false)]: "right",
	[get_percept("right", false), get_percept("right", true), get_percept("left", true)]: "suck",
	[get_percept("right", false), get_percept("right", true), get_percept("right", false)]: "left",
	[get_percept("right", false), get_percept("right", true), get_percept("right", true)]: "suck",
	[get_percept("right", true)]: "suck",
	[get_percept("right", true), get_percept("left", false)]: "wait",
	[get_percept("right", true), get_percept("left", false), get_percept("left", false)]: "right",
	[get_percept("right", true), get_percept("left", false), get_percept("left", true)]: "suck",
	[get_percept("right", true), get_percept("left", false), get_percept("right", false)]: "wait",
	[get_percept("right", true), get_percept("left", false), get_percept("right", true)]: "suck",
	[get_percept("right", true), get_percept("left", true)]: "suck",
	[get_percept("right", true), get_percept("left", true), get_percept("left", false)]: "right",
	[get_percept("right", true), get_percept("left", true), get_percept("left", true)]: "suck",
	[get_percept("right", true), get_percept("left", true), get_percept("right", false)]: "left",
	[get_percept("right", true), get_percept("left", true), get_percept("right", true)]: "suck",
	[get_percept("right", true), get_percept("right", false)]: "wait",
	[get_percept("right", true), get_percept("right", false), get_percept("left", false)]: "wait",
	[get_percept("right", true), get_percept("right", false), get_percept("left", true)]: "suck",
	[get_percept("right", true), get_percept("right", false), get_percept("right", false)]: "left",
	[get_percept("right", true), get_percept("right", false), get_percept("right", true)]: "suck",
	[get_percept("right", true), get_percept("right", true)]: "suck",
	[get_percept("right", true), get_percept("right", true), get_percept("left", false)]: "right",
	[get_percept("right", true), get_percept("right", true), get_percept("left", true)]: "suck",
	[get_percept("right", true), get_percept("right", true), get_percept("right", false)]: "wait",
	[get_percept("right", true), get_percept("right", true), get_percept("right", true)]: "suck",
}
###

func add_to_percept_sequence(percept: Percept):
	percept_sequence.append(percept)
	while (percept_sequence.size() > percept_sequence_max_size):
		percept_sequence.remove_at(0)

# returns "left", "right", "suck" or "wait"
func get_table_action() -> String:
	for sequence in table:
		if (percept_sequence.size() != sequence.size()):
			continue
		var sequences_match = true
		for i in percept_sequence.size():
			if percept_sequence[i].room_position != sequence[i].room_position \
				|| percept_sequence[i].room_is_dirty != sequence[i].room_is_dirty:
				sequences_match = false
				continue
		if sequences_match:
			return table[sequence]
	return "wait"
###

func reset():
	guessed_room_position = "left"
	cleaned_current = false

func move_right():
	act_move_right.emit()

func move_left():
	act_move_left.emit()

func suck():
	act_suck.emit()

func perceive():
	perceive_environment.emit()

func agent_program():
	#blind_agent()
	#reflex_agent()
	table_driven_agent()

func blind_agent():
	if (cleaned_current):
		if (guessed_room_position == "left"):
			move_right()
			guessed_room_position = "right"
		else:
			move_left()
			guessed_room_position = "left"
		cleaned_current = false
	else:
		suck()
		cleaned_current = true

func reflex_agent():
	perceive()
	if (room_is_dirty):
		suck()
	elif (room_position == "left"):
		move_right()
	else:
		move_left()

func table_driven_agent():
	perceive()
	add_to_percept_sequence(get_percept(room_position, room_is_dirty))
	match get_table_action():
		"left":
			move_left()
		"right":
			move_right()
		"suck":
			suck()
		_:
			return

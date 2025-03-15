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
	reflex_agent()

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

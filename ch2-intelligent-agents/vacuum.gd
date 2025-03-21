extends Node3D

signal moved_right
signal moved_left
signal sucked

var speed: float = 5
var right_pos_limit: float = 5
var left_pos_limit: float = -5
var suck_time: float = 1
var wants_to_move_right: bool = false
var wants_to_move_left: bool = false
var wants_to_suck: bool = false
var cur_suck_time: float = 0

func reset():
	wants_to_move_right = false
	wants_to_move_left = false
	wants_to_suck = false
	position.x = left_pos_limit
	scale = Vector3(3,3,3)

func update(delta: float) -> void:
	if (wants_to_move_right && position.x < right_pos_limit):
		position.x += speed * delta
		if (position.x >= right_pos_limit):
			wants_to_move_right = false
			moved_right.emit()
	if (wants_to_move_left && position.x > left_pos_limit):
		position.x -= speed * delta
		if (position.x <= left_pos_limit):
			wants_to_move_left = false
			moved_left.emit()
	if (wants_to_suck && cur_suck_time < suck_time):
		scale = Vector3(3,3,3) + 0.9 * Vector3.ONE * sin(cur_suck_time * PI)
		cur_suck_time += delta
		if (cur_suck_time >= suck_time):
			wants_to_suck = false
			scale = Vector3(3,3,3)
			sucked.emit()

func move_right():
	if (is_in_action()):
		print("Still executing the previous command..")
		return
	wants_to_move_right = true

func move_left():
	if (is_in_action()):
		print("Still executing the previous command..")
		return
	wants_to_move_left = true

func suck():
	if (is_in_action()):
		print("Still executing the previous command..")
		return
	cur_suck_time = 0
	wants_to_suck = true

func is_in_action() -> bool:
	return wants_to_move_right || wants_to_move_left || wants_to_suck

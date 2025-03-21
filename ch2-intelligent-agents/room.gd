extends Node3D

@export var mat: Material
@export var dirt_scene: PackedScene

var dirts: Array[Node3D]
var cleaning_time: float = 1
var cur_cleaning_time: float = 0
var is_cleaning: bool = false

func _process(delta: float) -> void:
	if (is_cleaning):
		cur_cleaning_time += delta
		if (cur_cleaning_time >= cleaning_time):
			cur_cleaning_time = cleaning_time
			is_cleaning = false
		for dirt in dirts:
			dirt.position = dirt.position + (Vector3(0, 0.5, 0) - dirt.position) * (cur_cleaning_time / cleaning_time)

func reset():
	remove_dirt()
	cur_cleaning_time = 0
	is_cleaning = false

func spawn_dirt():
	for i in range(5):
		var new_dirt = dirt_scene.instantiate() as Node3D
		add_child(new_dirt)
		new_dirt.position.x = (randi() % 6) - 2.5
		new_dirt.position.y = 0.5
		new_dirt.position.z = (randi() % 6) - 2.5
		dirts.push_back(new_dirt)

func remove_dirt():
	for dirt in dirts:
		remove_child(dirt)
	dirts.clear()

func is_dirty():
	return dirts.size() != 0

func animate_cleaning():
	is_cleaning = true
	cur_cleaning_time = 0

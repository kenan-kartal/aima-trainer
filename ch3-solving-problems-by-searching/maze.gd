class_name Ch3Maze

extends Node3D

const ROW := 30
const COL := 50
const WALL_REMOVE_CHANCE := 0.3

class MazeCell:
	var cell: Ch3Cell
	var i: int
	var j: int
	var visited: bool = false

	func _init(cell: Ch3Cell, i: int, j: int, visited: bool) -> void:
		self.cell = cell
		self.i = i
		self.j = j
		self.visited = visited

class MazeWall:
	var wall: Node3D
	var i: int
	var j: int
	var horizontal: bool

	func _init(wall: Node3D, i: int, j: int, horizontal: bool) -> void:
		self.wall = wall
		self.i = i
		self.j = j
		self.horizontal = horizontal

var maze_cells: Array[MazeCell] = []
var cell_scene := preload("res://ch3-solving-problems-by-searching/Cell.tscn")
var maze_walls_horizontal: Array[MazeWall] = []
var maze_walls_vertical: Array[MazeWall] = []
var wall_scene := preload("res://ch3-solving-problems-by-searching/wall.tscn")

func get_cell(i: int, j: int) -> MazeCell:
	return maze_cells[i+ROW*j]

func set_cell(i: int, j: int, cell: MazeCell) -> void:
	maze_cells[i+ROW*j] = cell

func get_wall_horizontal(i: int, j: int) -> MazeWall:
	return maze_walls_horizontal[i+ROW*j]

func set_wall_horizontal(i: int, j: int, wall: MazeWall) -> void:
	maze_walls_horizontal[i+ROW*j] = wall

func get_wall_vertical(i: int, j: int) -> MazeWall:
	return maze_walls_vertical[i+ROW*j]

func set_wall_vertical(i: int, j: int, wall: MazeWall) -> void:
	maze_walls_vertical[i+ROW*j] = wall

func get_cell_north(cell: MazeCell) -> MazeCell:
	if (cell.i > 0):
		return get_cell(cell.i-1, cell.j)
	return null

func get_cell_west(cell: MazeCell) -> MazeCell:
	if (cell.j > 0):
		return get_cell(cell.i, cell.j-1)
	return null

func get_cell_south(cell: MazeCell) -> MazeCell:
	if (cell.i < ROW-1):
		return get_cell(cell.i+1, cell.j)
	return null

func get_cell_east(cell: MazeCell) -> MazeCell:
	if (cell.j < COL-1):
		return get_cell(cell.i, cell.j+1)
	return null

func get_wall_north(cell: MazeCell) -> MazeWall:
	return get_wall_horizontal(cell.i, cell.j)

func get_wall_west(cell: MazeCell) -> MazeWall:
	return get_wall_vertical(cell.i, cell.j)

func get_wall_south(cell: MazeCell) -> MazeWall:
	return get_wall_horizontal(cell.i+1, cell.j)

func get_wall_east(cell: MazeCell) -> MazeWall:
	return get_wall_vertical(cell.i, cell.j+1)

func generate(seed: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	for maze_cell in maze_cells:
		if maze_cell:
			remove_child(maze_cell.cell)
	for maze_wall in maze_walls_horizontal:
		if maze_wall:
			remove_child(maze_wall.wall)
	for maze_wall in maze_walls_vertical:
		if maze_wall:
			remove_child(maze_wall.wall)
	for j in range(COL):
		for i in range(ROW):
			var cell: Ch3Cell = cell_scene.instantiate()
			add_child(cell)
			cell.position = 2 * Vector3(j, 0, i) + Vector3(1, 0, 1)
			set_cell(i, j, MazeCell.new(cell, i, j, false))
	for j in range(COL):
		for i in range(ROW+1):
			var wall: Node3D = wall_scene.instantiate()
			add_child(wall)
			wall.position = 2 * Vector3(j, 0, i) + Vector3(1, 0, 0)
			set_wall_horizontal(i, j, MazeWall.new(wall, i, j, true))
	for j in range(COL+1):
		for i in range(ROW):
			var wall: Node3D = wall_scene.instantiate()
			add_child(wall)
			wall.position = 2 * Vector3(j, 0, i) + Vector3(0, 0, 1)
			wall.rotate_y(PI/2)
			set_wall_vertical(i, j, MazeWall.new(wall, i, j, false))
	var stack: Array[MazeCell] = []
	var initial_maze_cell = get_cell(0, 0)
	initial_maze_cell.visited = true
	stack.push_back(initial_maze_cell)
	while (!stack.is_empty()):
		var maze_cell: MazeCell = stack.pop_back()
		var i := maze_cell.i
		var j := maze_cell.j
		var unvisited_cells: Array[MazeCell] = []
		var neighbour := get_cell_north(maze_cell)
		if neighbour && !neighbour.visited:
			unvisited_cells.push_back(neighbour)
		neighbour = get_cell_west(maze_cell)
		if neighbour && !neighbour.visited:
			unvisited_cells.push_back(neighbour)
		neighbour = get_cell_south(maze_cell)
		if neighbour && !neighbour.visited:
			unvisited_cells.push_back(neighbour)
		neighbour = get_cell_east(maze_cell)
		if neighbour && !neighbour.visited:
			unvisited_cells.push_back(neighbour)
		if unvisited_cells.size() > 0:
			stack.push_back(maze_cell)
			var next := unvisited_cells[rng.randi_range(0, unvisited_cells.size()-1)]
			next.visited = true
			stack.push_back(next)
			var maze_wall: MazeWall = null
			if next.i < maze_cell.i:
				maze_wall = get_wall_north(maze_cell)
			elif next.j < maze_cell.j:
				maze_wall = get_wall_west(maze_cell)
			elif next.i > maze_cell.i:
				maze_wall = get_wall_south(maze_cell)
			else:
				maze_wall = get_wall_east(maze_cell)
			remove_child(maze_wall.wall)
			if maze_wall.horizontal:
				set_wall_horizontal(maze_wall.i, maze_wall.j, null)
			else:
				set_wall_vertical(maze_wall.i, maze_wall.j, null)
	for i in range(1, ROW):
		for j in range(1, COL):
			var wall := get_wall_horizontal(i, j)
			if wall && rng.randf() < WALL_REMOVE_CHANCE:
				remove_child(wall.wall)
				set_wall_horizontal(i, j, null)
			wall = get_wall_vertical(i, j)
			if wall && rng.randf() < WALL_REMOVE_CHANCE:
				remove_child(wall.wall)
				set_wall_vertical(i, j, null)

func _init() -> void:
	maze_cells.resize(ROW*COL)
	maze_walls_horizontal.resize((ROW+1)*COL)
	maze_walls_vertical.resize(ROW*(COL+1))

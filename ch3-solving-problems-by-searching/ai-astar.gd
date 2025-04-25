class_name Ch3AI_AStar

class Ch3Node:
	var cell: Ch3Maze.MazeCell
	var parent: Ch3Node
	var cost: int
	var h: int

	func _init(cell: Ch3Maze.MazeCell, parent: Ch3Node, cost: int, h: int) -> void:
		self.cell = cell
		self.parent = parent
		self.cost = cost
		self.h = h

var maze: Ch3Maze
var init_cell: Ch3Maze.MazeCell
var goal_cell: Ch3Maze.MazeCell
var frontier: Array[Ch3Node]
var reached: Array[Ch3Maze.MazeCell]

func mark_path(node: Ch3Node) -> void:
	var curr := node
	while curr:
		if curr != init_cell && curr != goal_cell:
			curr.cell.cell.make_blue()
		curr = curr.parent

func h(cell: Ch3Maze.MazeCell) -> int:
	return abs(goal_cell.i - cell.i) + abs(goal_cell.j - cell.j)

func expand(node: Ch3Node) -> Array[Ch3Node]:
	var arr: Array[Ch3Node] = []
	var neighbour = maze.get_cell_south(node.cell)
	if neighbour && !maze.get_wall_south(node.cell):
		arr.push_back(Ch3Node.new(neighbour, node, node.cost+1, h(neighbour)))
	neighbour = maze.get_cell_east(node.cell)
	if neighbour && !maze.get_wall_east(node.cell):
		arr.push_back(Ch3Node.new(neighbour, node, node.cost+1, h(neighbour)))
	neighbour = maze.get_cell_north(node.cell)
	if neighbour && !maze.get_wall_north(node.cell):
		arr.push_back(Ch3Node.new(neighbour, node, node.cost+1, h(neighbour)))
	neighbour = maze.get_cell_west(node.cell)
	if neighbour && !maze.get_wall_west(node.cell):
		arr.push_back(Ch3Node.new(neighbour, node, node.cost+1, h(neighbour)))
	return arr

func init_search(init_cell: Ch3Maze.MazeCell, goal_cell: Ch3Maze.MazeCell, maze: Ch3Maze) -> void:
	self.maze = maze
	self.init_cell = init_cell
	self.goal_cell = goal_cell
	frontier = [Ch3Node.new(init_cell, null, 0, h(init_cell))]
	reached = [init_cell]
	init_cell.cell.make_green()
	goal_cell.cell.make_red()

func f_sort(lhs, rhs) -> bool:
	return lhs.cost + lhs.h <= rhs.cost + rhs.h

# Performs a single search step.
# Returns true if found a path to goal, false otherwise.
func search_step() -> bool:
	frontier.sort_custom(f_sort)
	var node = frontier.pop_front()
	if node.cell != init_cell:
		node.cell.cell.make_grey()
	for child in expand(node):
		var cell = child.cell
		if cell == goal_cell:
			mark_path(child)
			return true
		if !reached.has(cell):
			reached.push_back(cell)
			frontier.push_back(child)
			if cell != init_cell:
				cell.cell.make_yellow()
	return false

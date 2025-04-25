class_name Ch3AI_DFS

class Ch3Node:
	var cell: Ch3Maze.MazeCell
	var parent: Ch3Node
	var cost: int

	func _init(cell: Ch3Maze.MazeCell, parent: Ch3Node, cost: int) -> void:
		self.cell = cell
		self.parent = parent
		self.cost = cost

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

func expand(node: Ch3Node) -> Array[Ch3Node]:
	var arr: Array[Ch3Node] = []
	var neighbour = maze.get_cell_south(node.cell)
	if neighbour && !maze.get_wall_south(node.cell):
		arr.push_back(Ch3Node.new(neighbour, node, node.cost+1))
	neighbour = maze.get_cell_east(node.cell)
	if neighbour && !maze.get_wall_east(node.cell):
		arr.push_back(Ch3Node.new(neighbour, node, node.cost+1))
	neighbour = maze.get_cell_north(node.cell)
	if neighbour && !maze.get_wall_north(node.cell):
		arr.push_back(Ch3Node.new(neighbour, node, node.cost+1))
	neighbour = maze.get_cell_west(node.cell)
	if neighbour && !maze.get_wall_west(node.cell):
		arr.push_back(Ch3Node.new(neighbour, node, node.cost+1))
	return arr

func init_search(init_cell: Ch3Maze.MazeCell, goal_cell: Ch3Maze.MazeCell, maze: Ch3Maze) -> void:
	self.maze = maze
	self.init_cell = init_cell
	self.goal_cell = goal_cell
	frontier = [Ch3Node.new(init_cell, null, 0)]
	reached = [init_cell]
	init_cell.cell.make_green()
	goal_cell.cell.make_red()

# Performs a single search step.
# Returns true if found a path to goal, false otherwise.
func search_step() -> bool:
	var node = frontier.pop_back()
	if node.cell != init_cell:
		node.cell.cell.make_grey()
	var children := expand(node)
	var unreached := 0
	for child in children:
		if !reached.has(child.cell):
			unreached += 1
	for child in children:
		var cell = child.cell
		if cell == goal_cell:
			mark_path(child)
			return true
		if !reached.has(cell):
			reached.push_back(cell)
			if unreached > 1:
				frontier.push_back(node)
				node.cell.cell.make_yellow()
			frontier.push_back(child)
			if cell != init_cell:
				cell.cell.make_yellow()
			return false
	return false

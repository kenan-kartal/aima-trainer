class_name Ch3AI
extends Node3D

var ai_engine = null

func init_search(search_type: int, init_cell: Ch3Maze.MazeCell, goal_cell: Ch3Maze.MazeCell, maze: Ch3Maze) -> void:
	match search_type:
		0:
			ai_engine = Ch3AI_BFS.new()
		1:
			ai_engine = Ch3AI_DFS.new()
		2:
			ai_engine = Ch3AI_AStar.new()
	ai_engine.init_search(init_cell, goal_cell, maze)

func search_step() -> bool:
	return ai_engine.search_step()

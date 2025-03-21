@tool
extends Node

@export var room: Node3D
@export var mesh: MeshInstance3D

func _ready() -> void:
	mesh.set_surface_override_material(0, room.mat)

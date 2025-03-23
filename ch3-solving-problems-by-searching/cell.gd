class_name Ch3Cell
extends Node3D

var white := preload("res://materials/white.tres")
var grey := preload("res://materials/grey.tres")
var green := preload("res://materials/green.tres")
var yellow := preload("res://materials/yellow.tres")
var red := preload("res://materials/red.tres")
var blue := preload("res://materials/blue.tres")

@onready var mesh := $MeshInstance3D

func make_white() -> void:
	mesh.set_surface_override_material(0, white)

func make_grey() -> void:
	mesh.set_surface_override_material(0, grey)

func make_green() -> void:
	mesh.set_surface_override_material(0, green)

func make_yellow() -> void:
	mesh.set_surface_override_material(0, yellow)

func make_red() -> void:
	mesh.set_surface_override_material(0, red)

func make_blue() -> void:
	mesh.set_surface_override_material(0, blue)

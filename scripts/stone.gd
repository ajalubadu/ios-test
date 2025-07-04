class_name Stone
extends Node2D

enum StoneColor {
	BLACK,
	WHITE,
}

@export var color: StoneColor


func is_white() -> bool:
	return color == StoneColor.WHITE


func is_black() -> bool:
	return color == StoneColor.BLACK

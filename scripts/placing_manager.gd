extends Node2D

const BLACK_STONE = preload("res://scenes/black_stone.tscn")
const WHITE_STONE = preload("res://scenes/white_stone.tscn")

@export var grid : StoneGrid

var current_stone : PackedScene = BLACK_STONE


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("place stone"):
		var clicked_cell = grid.find_closest_cell_to_position(get_global_mouse_position(), 100)
		place_current_stone(clicked_cell)


func place_current_stone(cell: Vector2i):
	if cell in grid.get_open_cells():
		grid.add_stone(current_stone, cell)
		
		if current_stone == BLACK_STONE:
			current_stone = WHITE_STONE
		else: 
			current_stone = BLACK_STONE

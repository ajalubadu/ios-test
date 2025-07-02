extends Node2D

@export var grid : StoneGrid

var current_stone : int = grid.stone_type.BLACK


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("place stone"):
		var clicked_cell = grid.find_closest_cell_to_position(get_global_mouse_position(), 100)
		place_current_stone(clicked_cell)


func place_current_stone(cell: Vector2i):
	if cell in grid.get_open_cells():
		grid.add_stone(current_stone, cell)
		
		if current_stone == grid.stone_type.BLACK:
			current_stone = grid.stone_type.WHITE
		else: 
			current_stone = grid.stone_type.BLACK

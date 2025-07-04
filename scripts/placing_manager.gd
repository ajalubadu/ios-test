extends Node2D

@export var grid : StoneGrid

var current_stone_color : Stone.StoneColor = Stone.StoneColor.BLACK


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("place stone"):
		var clicked_cell = grid.find_closest_cell_to_position(get_global_mouse_position(), 100)
		place_current_stone(clicked_cell)


func place_current_stone(cell: Vector2i) -> void:
	if cell in grid.get_open_cells():
		grid.add_stone(current_stone_color, cell)
		
		var captured_groups = grid.find_all_captured_groups()
		var enemy_captured = false
		if captured_groups.size() == 0:
			pass
		else:
			for group in captured_groups:
				if grid.cells[group[0]].color != current_stone_color:
					grid.remove_group(group)
					enemy_captured = true
			if not enemy_captured:
				grid.remove_stone(cell)
				return
		
		if current_stone_color == Stone.StoneColor.BLACK:
			current_stone_color = Stone.StoneColor.WHITE
		else: 
			current_stone_color = Stone.StoneColor.BLACK

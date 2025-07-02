class_name StoneGrid
extends TileMapLayer

const BLACK_STONE = preload("res://scenes/black_stone.tscn")
const WHITE_STONE = preload("res://scenes/white_stone.tscn")

enum stone_type {
	NONE,
	BLACK,
	WHITE,
}

const board_size := Vector2(9,9)
const cell_size := Vector2(156,156)

var cells : Dictionary[Vector2i, stone_type] 


func _ready() -> void:
	for x in range(board_size.x):
		for y in range(board_size.y):
			cells[Vector2i(x,y)] = stone_type.NONE


func get_open_cells() -> Array[Vector2i]:
	var output : Array[Vector2i]
	
	for cell in cells:
		if cells[cell] == stone_type.NONE:
			output.append(cell)
	
	return output


func get_occupied_cells() -> Array[Vector2i]:
	var output : Array[Vector2i]
	
	for cell in cells:
		if cells[cell] != stone_type.NONE:
			output.append(cell)
	
	return output


func has_open_cell() -> bool:
	if get_open_cells().size() != 0:
		return true
	
	return false


func find_closest_cell_to_position(_position: Vector2, maximum_distance: float = INF) -> Vector2i:
	assert(has_open_cell())
	
	var output: Vector2i = Vector2i(-1,-1)
	
	for cell in get_open_cells():
		var cell_distance = abs((_position - to_global(map_to_local(cell))).length())
		var output_distance = abs((_position - to_global(map_to_local(output))).length())
		
		if cell_distance < maximum_distance and cell_distance < output_distance:
			output = cell
	
	return output


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		print(local_to_map(get_local_mouse_position()))
		print(find_group_at(local_to_map(get_local_mouse_position())))

func find_group_at(cell: Vector2i) -> Array[Vector2i]:
	var output: Array[Vector2i] = [cell]
	
	var stone_color : stone_type
	if cells[cell] == stone_type.NONE:
		return []
	elif cells[cell] == stone_type.WHITE:
		stone_color = stone_type.WHITE
	elif cells[cell] == stone_type.BLACK:
		stone_color = stone_type.BLACK
	
	#while check_adjacent_cells(output, stone_color) != output:
	for i in range(10):
		output = check_adjacent_cells(output, stone_color)
	
	return output


func check_adjacent_cells(current_group: Array[Vector2i], stone_color: stone_type) -> Array[Vector2i]:
	var output = current_group.duplicate(true)
	
	for cell in current_group:
		for direction in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
			if not cells.has(cell + direction):
				continue
			
			if cells[cell + direction] == stone_color and cell + direction not in output:
				output.append(cell + direction)
	
	return output


func add_stone(stone: int, cell: Vector2i):
	assert(cell in get_open_cells())
	
	var stone_scene: PackedScene
	
	if stone == stone_type.BLACK:
		stone_scene = BLACK_STONE
	elif stone == stone_type.WHITE:
		stone_scene = WHITE_STONE
	
	var new_stone = stone_scene.instantiate()
	new_stone.position = map_to_local(cell)
	add_child(new_stone)
	
	cells[cell] = stone

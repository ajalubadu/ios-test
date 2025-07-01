class_name StoneGrid
extends TileMapLayer


const board_size := Vector2(9,9)
const cell_size := Vector2(156,156)

var cells : Dictionary 


func _ready() -> void:
	for x in range(board_size.x):
		for y in range(board_size.y):
			cells[Vector2i(x,y)] = null
	
	
	print(find_closest_cell_to_position(Vector2.RIGHT))
	print(get_open_cells())


func get_open_cells() -> Array[Vector2i]:
	var output : Array[Vector2i] = []
	
	for cell in cells:
		if cells[cell] == null:
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


func add_stone(stone: PackedScene, cell: Vector2i):
	assert(cell in get_open_cells())
	
	var new_stone = stone.instantiate()
	new_stone.position = map_to_local(cell)
	new_stone.z_index = cell.x * cell.y
	add_child(new_stone)
	
	cells[cell] = new_stone

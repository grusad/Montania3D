extends Spatial

onready var camera = $Pivot/Camera
onready var object_list = $Options/UI/VBoxContainer/ObjectList
onready var ground = $Ground
onready var options = $Options
onready var props = $Props

var grid_map = []

func _ready():
	camera.options = options
	camera.connect("place", self, "on_object_placed")

func _on_CreateObjectButton_pressed():

	var object = AssetsLoader.build_asset(object_list.asset_descriptions[object_list.selected].path)
	add_child(object)
	camera.register_draggable_object(object)
	camera.object_follow_mouse(object)
	
	


func on_object_placed(node):
	_on_CreateObjectButton_pressed()
	
	var pos = node.global_transform.origin
	
	if grid_map.has(Vector3(pos.x, 0, pos.z)):
		print("Cant place here.")
		return
	
	grid_map.push_back(Vector3(pos.x, 0, pos.z))
	var forward = Vector3(pos.x, 0, pos.z - options.snap_size)
	var backward = Vector3(pos.x, 0, pos.z + options.snap_size)
	var left = Vector3(pos.x - options.snap_size, 0, pos.z)
	var right = Vector3(pos.x + options.snap_size, 0, pos.z)
	
	if grid_map.has(forward):
		var glass = generate_glass(node)
		glass.rotation_degrees = Vector3(0, 90, 0)
		
	if grid_map.has(backward):
		var glass = generate_glass(node)
		glass.rotation_degrees = Vector3(0, -90, 0)
		
	if grid_map.has(left):
		var glass = generate_glass(node)
		glass.rotation_degrees = Vector3(0, 180, 0)
		
	if grid_map.has(right):
		var glass = generate_glass(node)
		
func generate_glass(base_node):
	var instance = load("res://src/objects/Glass.tscn").instance()
	add_child(instance)
	instance.global_transform.origin = base_node.global_transform.origin
	instance.scale = Vector3(options.snap_size, 1, 1)
	return instance

func _on_PropsButton_pressed():
	for prop in props.get_children():
		prop.visible = not prop.visible

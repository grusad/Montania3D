extends Node


func load_asset_descriptions():
	
	#Objects loaded dynamically
	var resource_paths = []
	var dir = Directory.new()
	var file_extension = ".obj"
	var path = "res://assets/objects"
	dir.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		
		# This line is needed when running an exported version of the application. 
		#See: https://godotengine.og/qa/59637/cannot-traverse-asset-directory-in-android?show=59637#q59637
		if (OS.get_name() == "HTML5"):
			file_name = file_name.replace(".import", "")
		if dir.current_is_dir():
			print("Found directory " + file_name)
		else:
			if file_name.ends_with(file_extension):
				resource_paths.push_back(
					{
						"name": file_name.get_basename(),
						"path": path + "/" + file_name
					})
			print("Found file " + file_name)
			
		file_name = dir.get_next()
	
	return resource_paths
		
func build_asset(file_path):
	var object = ResourceLoader.load("res://src/Object.tscn").instance()
	var mesh_instance = object.get_node("MeshInstance")
	var mesh = ResourceLoader.load(file_path)
	mesh_instance.mesh = mesh
	mesh_instance.get_node("Outline").mesh = mesh.create_outline(0.05)
	object.get_node("CollisionShape").shape = mesh.create_convex_shape()
	return object
		

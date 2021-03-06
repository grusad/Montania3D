extends Camera

onready var pivot : Spatial = get_parent()
onready var tween : Tween = $Tween 
onready var grid_select = get_parent().get_parent().get_node("Ground/GridSelect")

const MOUSE_SENSITIVITY = 0.25
const RAY_LENGTH = 1000

var middle_button_pressed = false
var drag_node = null
var drag_node_offset = Vector3()
var options = null
var is_painting = false

signal place

func _physics_process(delta):
		var excludes = get_tree().get_nodes_in_group("draggable")
		var result = get_ray_result(excludes)
		if result:
			if options.snap_mode:
				var world_position = result['position']
				if world_position.x < 0:
					world_position.x -= 1
				if world_position.z < 0:
					world_position.z -= 1
					
				var grid_x = int(world_position.x / options.snap_size) * options.snap_size
				var grid_z = int(world_position.z / options.snap_size) * options.snap_size
				
				if drag_node:
					drag_node.set_translation(Vector3(grid_x, world_position.y, grid_z))
				
				grid_select.set_translation(Vector3(grid_x, grid_select.translation.y, grid_z))
			else:
				if drag_node:
					drag_node.set_translation(result['position'])
	

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_MIDDLE:
			if event.is_pressed():
				middle_button_pressed = true
			else:
				middle_button_pressed = false
		elif event.button_index == BUTTON_RIGHT and event.is_pressed():
			if is_painting:
				if drag_node:
					drag_node.queue_free()
					is_painting = false
			else:
				focus()
		# If mouse event not handled inside Object input handler (e.g snapping mode)
		elif event.button_index == BUTTON_LEFT and not event.is_pressed():
			if drag_node != null:
				drag_node.outline_mesh.visible = false
				var current_node = drag_node
				on_drag_end(drag_node)
				emit_signal("place", current_node)
				
		
		elif event.button_index == BUTTON_WHEEL_DOWN:
			if drag_node:
				drag_node.rotate_y(deg2rad(45))
			else:
				translate(Vector3(0, 0, 0.25))
		elif event.button_index == BUTTON_WHEEL_UP:
			if drag_node:
				drag_node.rotate_y(deg2rad(-45))
			else:
				translate(Vector3(0, 0, -0.25))
	
		
		
	if event is InputEventMouseMotion:
		if middle_button_pressed:
			pivot.rotation_degrees.x -= event.relative.y * MOUSE_SENSITIVITY
			pivot.rotation_degrees.y -= event.relative.x * MOUSE_SENSITIVITY

func focus():
	var result = get_ray_result()
	if result:
		var collider = result["collider"]
		var target = null
		if collider.is_in_group("draggable"):
			target = collider.global_transform.origin
		else:
			target = result["position"]
		
		tween.interpolate_property(pivot, "global_transform:origin", pivot.global_transform.origin,
		target, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
		
func get_ray_result(exclude = []):
	var mouse_position = get_viewport().get_mouse_position()
	var from = project_ray_origin(mouse_position)
	var to = from + project_ray_normal(mouse_position) * RAY_LENGTH
	var space_state = get_world().direct_space_state
	return space_state.intersect_ray(from, to, exclude, 0x7FFFFFFF, true, true)
	
func on_drag_start(node):
	drag_node = node
#	var initial_drag_position = get_ray_result(get_tree().get_nodes_in_group("draggable"))['position']
#	drag_node_offset = initial_drag_position - node.translation
	
	
func on_drag_end(node):
	drag_node = null
	
	
func register_draggable_object(node):
	node.connect("drag_start", self, "on_drag_start")
	node.connect("drag_end", self, "on_drag_end")
	
func object_follow_mouse(node):
	drag_node = node
	is_painting = true


extends Area

onready var outline_mesh = $MeshInstance/Outline

signal drag_start
signal drag_end


func _init():
	add_to_group("draggable")

func _input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed():
				outline_mesh.visible = true
				emit_signal("drag_start", self)
			else:
				outline_mesh.visible = false
				emit_signal("drag_end", self)
	

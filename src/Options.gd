extends Node


onready var debug_panel = $Debug
onready var snap_mode = $UI/VBoxContainer/SnapButton.pressed
onready var snap_size = $UI/VBoxContainer/SnapSize.value
	
func _on_SnapButton_toggled(button_pressed):
	snap_mode = button_pressed


func _on_DebugButton_toggled(button_pressed):
	debug_panel.visible = button_pressed


func _on_SnapSize_value_changed(value):
	snap_size = value

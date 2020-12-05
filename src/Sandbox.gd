extends Spatial

onready var camera = $Pivot/Camera
onready var object_list = $Options/UI/VBoxContainer/ObjectList

func _ready():
	$Pivot/Camera.options = $Options



func _on_CreateObjectButton_pressed():

	var object = AssetsLoader.build_asset(object_list.asset_descriptions[object_list.selected].path)
	add_child(object)
	camera.register_draggable_object(object)

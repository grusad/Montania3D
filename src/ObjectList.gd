extends OptionButton

var asset_descriptions = []

func _ready():
	var asset_description = AssetsLoader.load_asset_descriptions()
	for description in asset_description:
		add_item(description.name)
		asset_descriptions.push_back(description)

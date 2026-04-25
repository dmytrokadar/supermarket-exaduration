extends MarginContainer

@export var tick_ : Texture2D
var tick_texture : Texture2D = preload("res://Assets/UI/List/tick.png")
@onready var item_list : ItemList = $ItemList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tick_texture.get_image().resize(32, 32)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_item_list_multi_selected(index: int, selected: bool) -> void:
	print(tick_texture.get_size())
	var image = tick_texture.get_image()
	image.resize(32, 32)
	item_list.set_item_icon(index, ImageTexture.create_from_image(image) if selected else null)
	pass # Replace with function body.

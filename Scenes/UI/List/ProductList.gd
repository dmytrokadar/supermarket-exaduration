extends AspectRatioContainer

@export var font_color: Color = Color.BLACK
@export var font_color_completed: Color = Color.DARK_GREEN

var empty_texture: Texture2D = ImageTexture.create_from_image(Image.create_empty(32, 32, false, Image.FORMAT_RGBA8))
@onready var item_list : ItemList = $MarginContainer/ItemList
var tick_texture : Texture2D = preload("res://Assets/UI/List/tick.png")
var list_data: ListData
var index_map: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_list.add_theme_color_override("font_color", font_color)
	visible = false
	set_data(preload("res://Assets/supermarket/items.tres"))
	#set_data(preload("res://Assets/supermarket/items.tres"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent):
	if event.is_action_pressed("show_hide_list"):
		visible = !visible
	
	if event.is_action_pressed("fill_list"):
		set_data(preload("res://Assets/supermarket/items.tres"))
		
	if event.is_action_released("add_random"):
		list_data.add_random()
	pass

func set_data(data: ListData):
	item_list.clear()
	
	if (is_instance_valid(list_data)):
		list_data.item_updated.disconnect(_on_list_item_updated)
		list_data.item_completed.disconnect(_on_list_item_completed)
		list_data.list_completed.disconnect(_on_list_completed)
		list_data = null
	
	data.init()
	list_data = data
	
	for item_name in list_data.data.keys():
		var nice_name = GameProductsData.get_nice_name(item_name)
		var item_label: String = "%s: %s" % [nice_name, list_data.data.get(item_name)]
		var idx: int = item_list.add_item(item_label, empty_texture, false)
		index_map.set(item_name, idx)
		
	list_data.item_updated.connect(_on_list_item_updated)
	list_data.item_completed.connect(_on_list_item_completed)
	list_data.list_completed.connect(_on_list_completed)

func _on_list_item_updated(name: String, amount: int):
	var idx: int = index_map.get(name)
	var nice_name = GameProductsData.get_nice_name(name)
	item_list.set_item_text(idx, "%s: %s" % [nice_name, amount])
	pass
	
func _on_list_item_completed(name: String):
	var idx: int = index_map.get(name)
	item_list.set_item_icon(idx, tick_texture)
	#item_list.add_theme_color_override("font_color", item_list.get_theme_color("font_selected_color"))
	item_list.select(idx, true)
	pass
	
func _on_list_completed():
	item_list.add_theme_color_override("font_color", font_color_completed)
	pass

func _on_item_list_multi_selected(index: int, selected: bool) -> void:
	item_list.set_item_icon(index, ImageTexture.create_from_image(tick_texture.get_image()) if selected else empty_texture)
	pass # Replace with function body.
	

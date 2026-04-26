extends Resource
class_name ListData

signal list_completed
signal item_completed(name: String)
signal item_updated(name: String, new_amount: int)

@export_custom(PROPERTY_HINT_DICTIONARY_TYPE, "String;int") var data : Dictionary
@export_storage var incomplete_items

func add_random():
	var not_empty: Array
	
	for name in data.keys():
		if data.has(name) and data.get(name) > 0:
			not_empty.append(name)
	
	if not_empty.is_empty():
		printerr("Nothing to add")
	else:
		add_item(not_empty.pick_random())
	
	pass
	
func init():
	incomplete_items = data.keys().size()

func add_item(name: String, amount: int = 1) -> bool:
	
	if not data.has(name):
		printerr("Item not present in the list")
		return	false
		
	var item_amount: int = data.get(name);
	
	if item_amount - amount < 0:
		printerr("Incorrect amount")
		return false
		
	item_amount -= amount
	data.set(name, item_amount)
	
	print("Added %s %s to the list" % [name, amount])
	
	item_updated.emit(name, item_amount)
	
	if item_amount == 0:
		item_completed.emit(name)
		incomplete_items -= 1
		
	if incomplete_items == 0:
		list_completed.emit()
	
	return true

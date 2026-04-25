extends Node

# Наш словник: "назва_файлу": "красива назва"
var item_names = {
	"apple" : "Apple",
	"banana" : "Apple",
	"battery" : "Apple",
	"bread" : "Apple",
	"butter" : "Apple",
	"carrot" : "Apple",
	"chicken" : "Apple",
	"coffee" : "Apple",
	"cola" : "Apple",
	"cucumber" : "Apple",
	"egg" : "Apple",
	"john-pork" : "Apple",
	"meat" : "Apple",
	"milk" : "Apple",
	"mozarella" : "Apple",
	"pasta" : "Apple",
	"pineapple" : "Apple",
	"pizza" : "Apple",
	"popcarn" : "Apple",
	"potato" : "Apple",
	"rice" : "Apple",
	"salt" : "Apple",
	"sugar" : "Apple",
	"tea" : "Apple",
	"toilet-paper" : "Apple",
	"tomato" : "Apple",
	"water" : "Apple",
	"yogurt" : "Apple",
	"spagetti" : "Spagetti"
}

# Функція, яка видасть гарну назву або назву файлу, якщо перекладу немає
func get_nice_name(file_name: String) -> String:
	if item_names.has(file_name):
		return item_names[file_name]
	return file_name.capitalize() # Зробить з "red_apple" -> "Red Apple"

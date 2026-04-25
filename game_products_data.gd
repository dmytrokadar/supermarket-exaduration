extends Node

# Наш словник: "назва_файлу": "красива назва"
var item_names = {
	"apple" : "Apple",
	"banana" : "Banana minion",
	"battery" : "Battery pack",
	"bread" : "Bread cat",
	"butter" : "Butter pack",
	"carrot" : "Mrkev svazek",
	"chicken" : "RAW KFC",
	"coffee" : "Coffee",
	"cola" : "Pipsi Cola",
	"cucumber" : "Cucumber",
	"egg" : "EggDog",
	"john-pork" : "John Pork Is Calling",
	"meat" : "Steak",
	"milk" : "Bull`s Milk",
	"mozarella" : "Mozarella Ball",
	"pasta" : "Pasta",
	"pineapple" : "SpongeBob`s House",
	"pizza" : "Pizza",
	"popcarn" : "Popcorn",
	"potato" : "Potato",
	"rice" : "Rice Bag",
	"salt" : "1 gram of Salt",
	"sugar" : "Sugar Daddy",
	"tea" : "TatraTea",
	"toilet-paper" : "Valuable Resource",
	"tomato" : "Tomato",
	"water" : "Bo'o' o' wo'ah",
	"yogurt" : "Bull`s Milk Yogurt",
	"spaghetti" : "Spaghetti"
}

# Функція, яка видасть гарну назву або назву файлу, якщо перекладу немає
func get_nice_name(file_name: String) -> String:
	if item_names.has(file_name):
		return item_names[file_name]
	return file_name.capitalize() # Зробить з "red_apple" -> "Red Apple"

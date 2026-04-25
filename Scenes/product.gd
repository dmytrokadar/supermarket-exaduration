@tool # Це ключове слово змушує код працювати в редакторі!
extends Area3D

# Експортована змінна. Коли ми міняємо її в інспекторі, спрацьовує код нижче.
@export var item_texture: Texture2D:
	set(new_texture):
		item_texture = new_texture
		_update_logic() # Викликаємо оновлення, коли картинка змінилася

var item_name: String = ""
var player_ref: Node3D = null

# Використовуємо @onready, щоб знайти спрайт при старті гри
@onready var sprite = $Sprite3D

func _ready():
	# Ця частина спрацьовує, коли ми запускаємо гру
	# Переконуємося, що все оновилося при старті
	_update_logic()

# Основна функція оновлення, яка працює і в редакторі, і в грі
func _update_logic():
	if item_texture:
		# 1. Автоматично оновлюємо картинку на спрайті
		# Якщо ми в редакторі, $Sprite3D може бути ще null, тому перевіряємо
		if has_node("Sprite3D"):
			get_node("Sprite3D").texture = item_texture
		elif sprite:
			sprite.texture = item_texture
		
		# 2. Автоматично оновлюємо назву товару за назвою файлу
		var full_path = item_texture.resource_path
		item_name = full_path.get_file().get_basename()
		# print("Товар визначено: ", item_name)
	else:
		# Якщо картинку прибрали, очищаємо і спрайт
		if has_node("Sprite3D"):
			get_node("Sprite3D").texture = null
		item_name = ""

# Функція взаємодії для гравця (вона працює тільки в грі)
func interact():
	if not Engine.is_editor_hint(): # Перевіряємо, що ми НЕ в редакторі
		print("Взаємодія: взято '", item_name, "'")
		# return item_name # Повертаємо назву гравцеві, якщо треба

# Коли гравець заходить в зону продукту — зберігаємо посилання
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_ref = body

# Коли гравець виходить із зони — прибираємо посилання
func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_ref = null

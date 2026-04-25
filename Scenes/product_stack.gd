extends Node3D

@export var product_on_cart_prefab: PackedScene

var product_list: Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spawn_product"):
		spawn_product(product_on_cart_prefab)

func slide_stack():
	pass

func spawn_product(prefab):
	var inst = prefab.instantiate()
	add_child(inst)
	var box = inst as CSGBox3D
	inst.position =\
		Vector3(0, 0, 0) if product_list.is_empty() else product_list.back().position +\
		 Vector3(0, box.size.y, 0)
	product_list.append(inst)
	
	print("product_spawned", (inst.position))

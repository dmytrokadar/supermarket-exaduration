extends Node3D

@export var UNSTABLE_PRODUCT_COUNT = 20

@export var product_on_cart_prefab: PackedScene
#@export var max_tilt_degrees := 20.0
@export var tilt_curve: Curve
#@export var max_amplitude = .01
@export var phase_shift = 0.1
@export var speed = .002

var product_list: Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spawn_product"):
		spawn_product(product_on_cart_prefab)
	
	slide_stack(Time.get_ticks_msec())


func slide_stack(time):
	var max_amplitude = lerp(0.0, 1.0, clampf(float(product_list.size())/UNSTABLE_PRODUCT_COUNT, 0.0, 1.0))
	
	for obj in product_list:
		var heightFactor = float(product_list.find(obj)) / product_list.size()
		var currentAmplitude = max_amplitude * heightFactor
		
		var swayOffset = sin(time * speed - product_list.find(obj) * phase_shift)
		
		obj.position.x = currentAmplitude * swayOffset
		
		var swayOffsetz = cos(time * speed - product_list.find(obj) * phase_shift)
		obj.position.z = currentAmplitude * swayOffsetz
		#print(heightFactor)
	

func spawn_product(prefab):
	var inst = prefab.instantiate()
	add_child(inst)
	var box = inst as CSGBox3D
	inst.position =\
		Vector3(0, 0, 0) if product_list.is_empty() else product_list.back().position +\
		 Vector3(0, box.size.y, 0)
	product_list.append(inst)
	
	print("product_spawned", (inst.position))

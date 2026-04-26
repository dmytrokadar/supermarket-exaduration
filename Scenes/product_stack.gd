extends Node3D

@export var UNSTABLE_PRODUCT_COUNT = 20
@export var PLAYER: Node3D

@export var product_on_cart_prefab: PackedScene
#@export var max_tilt_degrees := 20.0
@export var tilt_curve: Curve
#@export var max_amplitude = .01
@export var phase_shift = 0.1
@export var speed = .002
@export var follow_speed: float = 15.0
@export var MAX_SPEED = 20
@export var MAX_SLIDE_DISTANCE: float = 1.0

var rigid_player: RigidBody3D

var product_list: Array[Node3D]
var product_base_local_positions: Array[Vector3]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rigid_player = PLAYER as RigidBody3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("spawn_product"):
		spawn_product(product_on_cart_prefab)
	

func _physics_process(delta: float) -> void:
	slide_stack(delta)
	
	if Input.is_physical_key_pressed(KEY_J):
		delete_products(2)
	

func slide_stack(delta):
	if rigid_player == null or product_list.is_empty():
		return

	var velocity: Vector3 = rigid_player.linear_velocity
	var velocity_xz := Vector2(velocity.x, velocity.z)
	var speed_ratio := clampf(velocity_xz.length() / MAX_SPEED, 0.0, 1.0)

	var slide_dir := Vector3.ZERO
	if velocity_xz.length() > 0.001:
		slide_dir = Vector3(-velocity_xz.x, 0.0, -velocity_xz.y).normalized()

	var blend := clampf(follow_speed * delta, 0.0, 1.0)
	var count := product_list.size()

	for i in range(count):
		var obj := product_list[i]
		if obj == null:
			continue

		var height_factor := float(i + 1) / float(count)
		var slide_amount := MAX_SLIDE_DISTANCE * speed_ratio * height_factor
		var target_global := to_global(product_base_local_positions[i]) + slide_dir * slide_amount

		obj.global_position = obj.global_position.lerp(target_global, blend)
	

func spawn_product(prefab):
	var inst := prefab.instantiate() as Node3D
	if inst == null:
		return

	add_child(inst)
	var box := inst as CSGBox3D
	inst.position =\
		Vector3(0, 0, 0) if product_list.is_empty() else product_list.back().position +\
		 Vector3(0, box.size.y, 0)
	product_list.append(inst)
	product_base_local_positions.append(inst.position)
	
	print("product_spawned", (inst.position))

func delete_products(amount: int):
	print("deleting")
	for i in range(amount):
		if product_list.size() < 3:
			return
		var p: Node3D = product_list.pop_back()
		product_base_local_positions.pop_back()
		p.queue_free()

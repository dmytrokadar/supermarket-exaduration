extends VehicleBody3D

@onready var head = $Head
@onready var interact_ray: RayCast3D = $Head/InteractRay

@export var MAX_STEER = 0.9
@export var ENGINE_POWER = 300
@export var MOUSE_SENSITIVITY = 0.2
@export var CAMERA_MIN_PITCH: float = -89.0
@export var CAMERA_MAX_PITCH: float = 89.0

var is_mouse_visible = false
var look_yaw: float = 0.0
var look_pitch: float = 0.0

# HUD elements
var crosshair_dot: Label
var interact_hint: Label
var hint_panel: PanelContainer

# Reference to the ProductList UI
var product_list: Node = null

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	look_yaw = head.rotation.y
	look_pitch = head.rotation.x
	add_to_group("player")
	_create_hud()
	# Find the ProductList node in the scene tree
	product_list = get_tree().root.find_child("ProductList", true, false)

# Creates HUD with crosshair dot and interaction hint panel
func _create_hud() -> void:
	var canvas_layer = CanvasLayer.new()
	canvas_layer.name = "HUD"
	add_child(canvas_layer)

	# Full-screen root control
	var hud_root = Control.new()
	hud_root.name = "HUDRoot"
	hud_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas_layer.add_child(hud_root)
	hud_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# === Crosshair dot — always centered on screen ===
	var crosshair_center = CenterContainer.new()
	crosshair_center.name = "CrosshairCenter"
	crosshair_center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hud_root.add_child(crosshair_center)
	crosshair_center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	crosshair_dot = Label.new()
	crosshair_dot.name = "Crosshair"
	crosshair_dot.text = "●"
	crosshair_dot.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	crosshair_dot.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	crosshair_dot.add_theme_font_size_override("font_size", 12)
	crosshair_dot.add_theme_color_override("font_color", Color.WHITE)
	crosshair_dot.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.5))
	crosshair_dot.add_theme_constant_override("outline_size", 2)
	crosshair_dot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	crosshair_center.add_child(crosshair_dot)

	# === Hint panel — semi-transparent dark box with product name + key prompt ===
	hint_panel = PanelContainer.new()
	hint_panel.name = "HintPanel"
	hint_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hint_panel.visible = false

	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = Color(0, 0, 0, 0.55)
	bg_style.corner_radius_top_left = 8
	bg_style.corner_radius_top_right = 8
	bg_style.corner_radius_bottom_left = 8
	bg_style.corner_radius_bottom_right = 8
	bg_style.content_margin_left = 20
	bg_style.content_margin_right = 20
	bg_style.content_margin_top = 8
	bg_style.content_margin_bottom = 8
	hint_panel.add_theme_stylebox_override("panel", bg_style)

	interact_hint = Label.new()
	interact_hint.name = "InteractHint"
	interact_hint.text = ""
	interact_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	interact_hint.add_theme_font_size_override("font_size", 16)
	interact_hint.add_theme_color_override("font_color", Color.WHITE)
	interact_hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hint_panel.add_child(interact_hint)

	hud_root.add_child(hint_panel)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not is_mouse_visible:
		look_yaw = wrapf(look_yaw - deg_to_rad(event.relative.x * MOUSE_SENSITIVITY), -PI, PI)
		look_pitch = clamp(
			look_pitch - deg_to_rad(event.relative.y * MOUSE_SENSITIVITY),
			deg_to_rad(CAMERA_MIN_PITCH),
			deg_to_rad(CAMERA_MAX_PITCH)
		)
		head.rotation.x = look_pitch
		head.rotation.y = look_yaw
		head.rotation.z = 0

func _physics_process(delta):
	steering = move_toward(steering, Input.get_axis("right", "left") * MAX_STEER, delta * 10)
	engine_force = Input.get_axis("forward", "backward") * ENGINE_POWER

	if Input.is_action_just_pressed("unattach_cursor"):
		if is_mouse_visible:
			is_mouse_visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			is_mouse_visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Interaction with products via raycast
	# Raycast hits SpriteHitbox (StaticBody3D), its parent is the product (Area3D)
	if interact_ray.is_colliding():
		var collider = interact_ray.get_collider()
		var product = collider.get_parent() if collider else null
		if product and product.has_method("interact") and product.get("player_ref") != null:
			# Player is inside product zone AND aiming at the sprite
			var nice_name = GameProductsData.get_nice_name(product.item_name)
			interact_hint.text = nice_name + "\n[E] Pick up"
			hint_panel.visible = true
			crosshair_dot.add_theme_color_override("font_color", Color.YELLOW)

			if Input.is_action_just_pressed("interact"):
				product.interact()
				add_to_cart(product)
		else:
			_hide_interact_hint()
	else:
		_hide_interact_hint()

	# Keep hint panel centered below crosshair
	_update_hint_position()

# Centers the hint panel horizontally, 20px below screen center
func _update_hint_position() -> void:
	if hint_panel and hint_panel.visible:
		var vp_size = get_viewport().get_visible_rect().size
		hint_panel.position = Vector2(
			(vp_size.x - hint_panel.size.x) / 2.0,
			vp_size.y / 2.0 + 20
		)

func _hide_interact_hint() -> void:
	if hint_panel:
		hint_panel.visible = false
	if crosshair_dot:
		crosshair_dot.add_theme_color_override("font_color", Color.WHITE)

# Called when the player picks up a product
func add_to_cart(product_node: Node) -> void:
	var product_name = product_node.item_name if product_node.has_method("interact") else "unknown"
	var nice_name = GameProductsData.get_nice_name(product_name)
	print("[Cart] Added: ", nice_name)
	# Update the shopping list UI
	if product_list and product_list.list_data:
		product_list.list_data.add_item(product_name)

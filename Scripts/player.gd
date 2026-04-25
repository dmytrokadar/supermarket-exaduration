extends VehicleBody3D

@onready var head = $Head

@export var MAX_STEER = 0.9
@export var ENGINE_POWER = 300
@export var MOUSE_SENSITIVITY = 0.2
@export var CAMERA_MIN_PITCH: float = -89.0
@export var CAMERA_MAX_PITCH: float = 89.0

var is_mouse_visible = false
var look_yaw: float = 0.0
var look_pitch: float = 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	look_yaw = head.rotation.y
	look_pitch = head.rotation.x

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
			

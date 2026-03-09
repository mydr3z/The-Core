extends Node3D
class_name Player


const EYE_HEIGHT := 1.5;
const SPEED := 1.5;
const MOUSE_SENSITIVITY_HDG := 0.002;
const MOUSE_SENSITIVITY_PITCH := 0.002;
const VERTICAL_FOV_RADIANS := 1.5;


var _camera : Camera3D;



func _init(pos : Vector3) -> void:
	set_position(pos);


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	_camera = Camera3D.new();
	_camera.set_position(Vector3(0.0, EYE_HEIGHT, 0.0));
	add_child(_camera);


func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		# поворот туловища по курсу:
		#rotate_y(-event.relative.x * MOUSE_SENSITIVITY_HDG);
		#rotation.y -= event.relative.x * MOUSE_SENSITIVITY_HDG;
		rotate(transform.basis.y, -event.relative.x * MOUSE_SENSITIVITY_HDG);
		# поворот камеры по тангажу:
		_camera.rotation.x -= event.relative.y * MOUSE_SENSITIVITY_PITCH;
		_camera.rotation.x = clamp(_camera.rotation.x, -VERTICAL_FOV_RADIANS, VERTICAL_FOV_RADIANS);


func _process(delta: float) -> void:
	# выравнивание игрока по вертикали:
	transform.basis = WorldPhysics.get_correct_basis(transform.basis, position);
	# коррекция высоты:
	position = WorldPhysics.get_correct_position(position);
	# получение направления движения:
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down");
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized();
	position += direction * SPEED * delta;

extends Node3D
class_name Player


const EYE_HEIGHT := 1.5;

const SPEED := 1.5;
const RUN_SPEED := 3.0;

const MOUSE_SENSITIVITY_HDG := 0.002;
const MOUSE_SENSITIVITY_PITCH := 0.002;
const VERTICAL_FOV_RADIANS := 1.5;

const JUMP_POWER := 10.0;

var _camera : Camera3D;

var _is_in_jump := false;
var _vel_y := 0.0;
var _height_metres := 0.0;


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
		rotate(transform.basis.y, -event.relative.x * MOUSE_SENSITIVITY_HDG);
		# поворот камеры по тангажу:
		_camera.rotation.x -= event.relative.y * MOUSE_SENSITIVITY_PITCH;
		_camera.rotation.x = clamp(_camera.rotation.x, -VERTICAL_FOV_RADIANS, VERTICAL_FOV_RADIANS);


func _process(delta: float) -> void:
	if _is_in_jump:
		if _height_metres < 0.0:
			_height_metres = 0.0;
			_is_in_jump = false;
		else:
			_vel_y -= WorldPhysics.get_gravity_accel(position) * delta;
			_height_metres += _vel_y * delta;
	# выравнивание игрока по вертикали:
	transform.basis = WorldPhysics.get_correct_basis(transform.basis, position);
	# коррекция высоты:
	position = WorldPhysics.get_correct_position(position) - position.normalized() * _height_metres;
	# получение направления движения:
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down");
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized();
	position += direction * RUN_SPEED * delta if Input.is_action_pressed("ui_run") else direction * SPEED * delta;
	
	if Input.is_action_just_pressed("ui_jump"):
		_jump();


func _jump() -> void:
	if not _is_in_jump:
		_vel_y = JUMP_POWER;
		_is_in_jump = true;

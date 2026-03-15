extends Node


const EARTH_RADIUS := 20.0;

const GRAVITY = 9.8;


func get_earth_radius() -> float:
	return EARTH_RADIUS;


func get_rand_pos_on_grnd() -> Vector3:
	var rand_vec := Vector3(
		randf(),
		randf(),
		randf()
	) - Vector3(0.5, 0.5, 0.5);
	return rand_vec.normalized() * EARTH_RADIUS;


func get_correct_basis(basis : Basis, position : Vector3) -> Basis:
	var gravity_dir := -position.normalized();
	basis.y = gravity_dir;
	# считаем x боковой осью, определяем с помощью "старой" боковой оси новую ось вперед:
	basis.z = basis.x.cross(basis.y).normalized();
	basis.x = basis.y.cross(basis.z).normalized();
	return basis;


func get_correct_position(position : Vector3) -> Vector3:
	return position.normalized() * EARTH_RADIUS;


func get_gravity_accel(position : Vector3) -> float:
	return GRAVITY;

extends Node3D


const CUBE_SIZE_MIN : float = 5.0;
const CUBE_SIZE_MAX : float = 10.0;

const QUANTITY_OF_CUBES : int = 500;
const QUANTITY_OF_SPHERES : int = 100;


var _earth_sphere : CSGSphere3D;


func _ready() -> void:
	_earth_sphere = $earth;
	_earth_sphere.set_radius(WorldPhysics.get_earth_radius());
	add_child(Player.new(Vector3(0.0, 0.0, WorldPhysics.get_earth_radius())));
	_create_spheres();
	_create_cubes();


func _create_spheres() -> void:
	for i in QUANTITY_OF_SPHERES:
		var sphere := CSGSphere3D.new();
		sphere.set_position(WorldPhysics.get_rand_pos_on_grnd());
		add_child(sphere);


func _create_cubes() -> void:
	for i in QUANTITY_OF_CUBES:
		var cube := CSGBox3D.new();
		cube.size *= randf_range(CUBE_SIZE_MIN, CUBE_SIZE_MAX);
		cube.set_position(WorldPhysics.get_rand_pos_on_grnd());
		cube.basis = WorldPhysics.get_correct_basis(cube.basis, cube.position);
		add_child(cube);

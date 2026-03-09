extends Node3D


var _earth_sphere : CSGSphere3D;


func _ready() -> void:
	_earth_sphere = $earth;
	_earth_sphere.set_radius(WorldPhysics.get_earth_radius());
	add_child(Player.new(Vector3(0.0, 0.0, WorldPhysics.get_earth_radius())));
	_create_spheres();
	_create_cubes();


func _create_spheres() -> void:
	for i in 100:
		var sphere := CSGSphere3D.new();
		sphere.set_position(WorldPhysics.get_rand_pos_on_grnd());
		add_child(sphere);


func _create_cubes() -> void:
	for i in 100:
		var cube := CSGBox3D.new();
		cube.set_position(WorldPhysics.get_rand_pos_on_grnd());
		cube.basis = WorldPhysics.get_correct_basis(cube.basis, cube.position);
		add_child(cube);

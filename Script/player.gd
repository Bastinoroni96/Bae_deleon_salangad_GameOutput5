extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var pivot: Node3D = $CamRoot

# for camera movement sensitivity
@export var sens = 0.1

@onready var body: MeshInstance3D = $MeshInstance3D
@onready var camera_3d: Camera3D = $CamRoot/SpringArm3D/Camera3D

# for guns
@export var max_distance: float = 100.0  # Adjust this to suit your scene's scale
@onready var rifle: MeshInstance3D = $MeshInstance3D/rifle
@onready var ray_cast_3d: RayCast3D = $MeshInstance3D/rifle/RayCast3D

# for bullets
var bullet = load("res://Scene/bullet.tscn")
var instance

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion:
		# rotateCamera
		pivot.rotate_y(deg_to_rad(-event.relative.x * sens))
		pivot.rotation.x -= deg_to_rad(event.relative.y * sens)
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(45))
		
		# rotateBody
		body.rotate_y(deg_to_rad(-event.relative.x * sens))
		
		# rotateWeapon to Center
		var viewport_center = Vector2(
			camera_3d.get_viewport().get_visible_rect().size / 2
		)  # Center of the viewport
		var ray_origin = camera_3d.project_ray_origin(viewport_center)
		var ray_direction = camera_3d.project_ray_normal(viewport_center)
		var target_position = ray_origin + ray_direction * max_distance
		
		# Make the weapon look at the target position
		rifle.look_at(target_position)



		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	 # quit button
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("shoot"):
		instance = bullet.instantiate()
		instance.position = rifle.global_position
		instance.transform.basis = rifle.global_transform.basis
		get_parent().add_child(instance)
		
	





	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (body.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

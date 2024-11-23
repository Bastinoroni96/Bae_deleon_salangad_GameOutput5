extends Node3D

var health = 4
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_got_hit(dam: Variant) -> void:
	health -= 1
	gpu_particles_3d.emitting=true
	if health <= 0:
		
		queue_free()
	

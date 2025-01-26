extends Node3D

@onready var blood = $blood

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func dead(event):
	blood.emitting = true
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

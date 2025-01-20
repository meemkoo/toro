extends Control

var rng = RandomNumberGenerator.new()
@export
var color1: Color = Color.from_hsv(rng.randf_range(0, 1), 1, 1, 1)
var hue: float = rng.randf_range(0, 1)

@export 
var pname: String;


func _ready() -> void:
    pass


func _process(delta: float) -> void:
    if hue < 1:
        hue += rng.randf_range(0, 0.01)
    else:
        hue = 0
    color1 = Color.from_hsv(hue, 1, 1, 1)
    self.set(pname, color1)
    

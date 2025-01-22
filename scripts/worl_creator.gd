extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var img = Image.load_from_file("res://maps/test1.png")
    var array = []
    for i in range(img.get_width()):
        var cwbb = []
        for j in range(img.get_height()):
            var t = null
            match img.get_pixel(j, i):
                _:
                    pass
            cwbb.append(img.get_pixel(j, i))
        array.append(cwbb)
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

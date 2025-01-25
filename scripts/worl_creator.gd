extends Node

@onready
var mo = $"../MapObjects"
@onready
var mos = $"../MapObjectsSource"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var img = Image.load_from_file("res://maps/test1.png")
    var array = []
    for i in range(img.get_width()):
        var cwbb = []
        for j in range(img.get_height()):
            var t = null
            match img.get_pixel(j, i):
                Color("000000"):
                    t = ["Wall", "wall", 11]
                Color("ffffff"):
                    t = ["Air", "air", 1]
                Color("00ff12"):
                    t = ["Level end", "lend", 2]
                Color("0400ff"):
                    t = ["Level start", "lstart", 3]
                Color("15293a"):
                    t = ["Staircase", "stairs", 4]
                Color("848484"):
                    t = ["Breakable wall/locked door", "xwall", 5]
                Color("ff0000"):
                    t = ["Stage 1 enemy", "e1", 6]
                Color("ffe800"):
                    t = ["Stage 2 enemy", "e2", 7]
                Color("46c9f7"):
                    t = ["Stage 3 enemy", "e3", 8]
                Color("9800ff"):
                    t = ["Sniper", "sniper", 9]
                Color("ff6d00"):
                    t = ["Pit", "pit", 10]
            cwbb.append(t)
            var nut = get_node("../MapObjectsSource/{0}".format([t[1]])).duplicate()
            nut.transform.origin = Vector3(i, 0, j)
            # nut.scale = Vector3(1/t[2], 1, 1/t[2])
            
            #var nut: MeshInstance3D = $"../MapObjectsSource/Wall".duplicate()
            mo.add_child(nut)
        array.append(cwbb)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

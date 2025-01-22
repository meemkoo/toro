extends Node

@onready
var mo = $"../MapObjects"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var img = Image.load_from_file("res://maps/test1.png")
    var array = []
    for i in range(img.get_width()):
        var cwbb = []
        for j in range(img.get_height()):
            var t = null
            match img.get_pixel(j, i):
                Color("000000"): t = "Wall"
                Color("ffffff"): t = "Air titkok"
                Color("00ff12"): t = "Level end"
                Color("0400ff"): t = "Level start"
                Color("15293a"): t = "Staircase"
                Color("848484"): t = "Breakable wall/locked door"
                Color("ff0000"): t = "Stage 1 enemy"
                Color("ffe800"): t = "Stage 2 enemy"
                Color("46c9f7"): t = "Stage 3 enemy"
                Color("9800ff"): t = "Sniper"
                Color("ff6d00"): t = "Pit"
            cwbb.append(t)
            var nut: MeshInstance3D = $"../MapObjectsBase/Wall".duplicate()
            
            var material = StandardMaterial3D.new()
            material.albedo_color = img.get_pixel(j, i)
            nut.set_surface_override_material(0, material)
            # nut.material_override = material
            
            nut.transform.origin = Vector3(i, 0, j)
            
            mo.add_child(nut)
        array.append(cwbb)
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

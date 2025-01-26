extends Node

@onready
var mo = $"../MapObjects"
@onready
var mos = $"../MapObjectsSource"

#var s = [
        #[1,0,0],
        #[0,0,0],
        #[1,1,0],
        #
        #[1,1,0],
        #[0,1,0],
        #[0,0,0],
        #
        #
        #[1,1,0],
        #[1,0,0],
        #[1,1,1],
        #
        #[1,0,1],
        #[1,0,0],
        #[1,1,1],
        #
        #
        #[0,0,0],
        #[0,0,1],
        #[1,0,0],
        #
        #[1,0,1],
        #[0,0,1],
        #[1,0,0],
        #
        #
        #[0,0,0],
        #[0,1,0],
        #[0,0,1],
        #
        #[0,1,0],
        #[0,1,1],
        #[0,0,1],
        #
        #
        #[0,1,0],
        #[1,1,0],
        #[0,1,1],
        #
        #[1,1,0],
        #[1,1,1],
        #[0,1,1],
        #
        #
        #[0,0,1],
        #[0,1,1],
        #[1,0,1],
        #
        #[1,0,1],
        #[1,1,1],
        #[0,1,1],
#]

var a := Vector3(0, 1, 0) # if you want the cube centered on grid points
var b := Vector3(1, 1, 0) # you can subtract a Vector3(0.5, 0.5, 0.5)
var c := Vector3(1, 0, 0) # from each of these
var d := Vector3(0, 0, 0)
var e := Vector3(0, 1, 1)
var f := Vector3(1, 1, 1)
var g := Vector3(1, 0, 1)
var h := Vector3(0, 0, 1)

var vertices := [   # faces (triangles)
    b,a,d,  b,d,c,  # N
    e,f,g,  e,g,h,  # S
    a,e,h,  a,h,d,  # W
    f,b,c,  f,c,g,  # E
    a,b,f,  a,f,e,  # T
    h,g,c,  h,c,d,  # B
]



func isValidPos(i, j, n, m):
 
    if (i < 0 or j < 0 or i > n - 1 or j > m - 1):
        return 0
    return 1
 
 
# Function that returns all adjacent elements
func getadj(arr, x, y):
    var n = len(arr)
    var m = len(arr[0])
    var v = {
        "N": null,
        "E": null,
        "S": null,
        "W": null,
        "T": null,
        "B": null,
    }
    #if (isValidPos(i - 1, j - 1, n, m)):
        #v.append(arr[i - 1][j - 1])
    if (isValidPos(x - 1, y, n, m)):
        v["W"] = arr[x - 1][y]
    #if (isValidPos(i - 1, j + 1, n, m)):
        #v.append(arr[i - 1][j + 1])
    if (isValidPos(x, y - 1, n, m)):
        v["N"] = arr[x][y - 1]
    if (isValidPos(x, y + 1, n, m)):
        v["S"] = arr[x][y + 1]
    #if (isValidPos(i + 1, j - 1, n, m)):
        #v.append(arr[i + 1][j - 1])
    if (isValidPos(x + 1, y, n, m)):
        v["E"] = arr[x + 1][y]
    #if (isValidPos(i + 1, j + 1, n, m)):
        #v.append(arr[i + 1][j + 1])
    return v


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var img = Image.load_from_file("res://maps/test1.png")
    var arrayonce = []
    for i in range(img.get_width()):
        var cwbb = []
        for j in range(img.get_height()):
            var t = null
            match img.get_pixel(i, j):
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
        arrayonce.append(cwbb)

    
    for x in range(img.get_width()):
        for y in range(img.get_height()):
            if arrayonce[x][y][2] == 3:
                print()
            if arrayonce[x][y][2] == 11:
                var test11 = getadj(arrayonce, x, y)
                #var t24 = []
                #for i1 in range(0, len(s), 3):
                    #t24.append(s.slice(i1, i1+3))

                var arr_mesh = ArrayMesh.new()
                var colors := []
                for i2 in range(vertices.size()):
                    colors.append(Color.RED)
    
                var arrays := []
                arrays.resize(Mesh.ARRAY_MAX)
                arrays[Mesh.ARRAY_VERTEX] = PackedVector3Array(vertices)
                arrays[Mesh.ARRAY_COLOR] = PackedColorArray(colors)
                arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
                # mesh.surface_set_material(0, your_material)   # will need uvs if using a texture
                # your_material.vertex_color_use_as_albedo = true # will need this for the array of colors
                
                var nut = get_node("../MapObjectsSource/{0}".format([arrayonce[x][y][1]])).duplicate()
                nut.transform.origin = Vector3(x, 0, y)
                nut.get_child(0).mesh = arr_mesh
                mo.add_child(nut)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

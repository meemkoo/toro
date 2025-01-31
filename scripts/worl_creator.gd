extends Node

@onready
var mo = $"../MapObjects"
@onready
var mos = $"../MapObjectsSource"
@onready
var player_main = $"../Player"
@onready
var eeeeeeeeeeee = $"../CanvasLayer/Label"

@onready
var escene = preload("res://scenes/menu.tscn").instantiate()

var levels = {}

var lidx = 0;
var fidx = 0;

const MAPSCALEFACTOR = 4
const MSF = MAPSCALEFACTOR

var a := MSF*Vector3(0, 1, 0) # if you want the cube centered on grid points
var b := MSF*Vector3(1, 1, 0) # you can subtract a Vector3(0.5, 0.5, 0.5)
var c := MSF*Vector3(1, 0, 0) # from each of these
var d := MSF*Vector3(0, 0, 0)
var e := MSF*Vector3(0, 1, 1)
var f := MSF*Vector3(1, 1, 1)
var g := MSF*Vector3(1, 0, 1)
var h := MSF*Vector3(0, 0, 1)

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


func load_map(img: Image, sources: Node3D, player: Node3D) -> Node3D:
    var levelroot = Node3D.new()
    
    var arrayonce = []
    for i in range(img.get_width()):
        var cwbb = []
        for j in range(img.get_height()):
            var t = null
            match img.get_pixel(i, j):
                Color("000000"):
                    t = ["Wall", "wall", 11, false] # Name, computer name, id, walltype
                Color("ffffff"):
                    t = ["Air", "air", 1, false]
                Color("00ff12"):
                    t = ["Level end", "lend", 2, false]
                Color("0400ff"):
                    t = ["Level start", "lstart", 3, false]
                Color("15293a"):
                    t = ["Staircase", "stairs", 4, false]
                Color("848484"):
                    t = ["Breakable wall", "xwall", 5, true]
                Color("ff0000"):
                    t = ["Stage 1 enemy", "e1", 6, false]
                Color("ffe800"):
                    t = ["Stage 2 enemy", "e2", 7, false]
                Color("46c9f7"):
                    t = ["Stage 3 enemy", "e3", 8, false]
                Color("9800ff"):
                    t = ["Sniper", "sniper", 9, false]
                Color("ff6d00"):
                    t = ["Pit", "pit", 10, false]
                Color("3f3f3f"):
                    t = ["Locked Door", "ldoor", 12, false]
                _:
                    t = ["Wall", "wall", 11, false]
            cwbb.append(t)
        arrayonce.append(cwbb)

    var wallmat = StandardMaterial3D.new()
    wallmat.vertex_color_use_as_albedo = true # will need this for the array of colors
    
    
    for x in range(img.get_width()):
        for y in range(img.get_height()):
            var cell = arrayonce[x][y]
            var nut = null;
            if cell[2] == 4:
                nut = get_node("{0}/{1}".format([sources.get_path(), "lend"])).duplicate()
            else:
                nut = get_node("{0}/{1}".format([sources.get_path(), cell[1]])).duplicate()
            nut.transform.origin = Vector3(MSF*x, 0, MSF*y)
            levelroot.add_child(nut)
            
            if cell[2] != 10:
                var boxbox = CSGBox3D.new()
                boxbox.transform.origin = Vector3(MSF*x, -2, MSF*y)
                boxbox.transform = boxbox.transform.scaled_local(Vector3(4,4,4))
                boxbox.use_collision = true
                levelroot.add_child(boxbox)
            if cell[2] >= 6 and cell[2] <= 8:
                pass
            if cell[2] == 3:
                player.transform.origin = nut.transform.origin + Vector3(0.5, 0.5, 0.5)*MSF
            if cell[2] not in [11]:
                nut.transform.origin += Vector3(0.5, 0.5, 0.5)*MSF
            if cell[2] in [11]:
                var test11 = getadj(arrayonce, x, y)
                var bvert = []
                if test11['N']:
                    if test11['N'][2] != 11:
                        bvert += vertices.slice(0, 6)
                if test11['E']:
                    if test11['E'][2] != 11:
                        bvert += vertices.slice(18, 24)
                if test11['S']:
                    if test11['S'][2] != 11:
                        bvert += vertices.slice(6, 12)
                if test11['W']:
                    if test11['W'][2] != 11:
                        bvert += vertices.slice(12, 18)

                var arr_mesh = ArrayMesh.new()
                var colors := []
                for i2 in range(bvert.size()):
                    if cell[2] == 5:
                        wallmat = StandardMaterial3D.new()
                        colors.append(Color.GREEN_YELLOW)
                    else:
                        colors.append(Color.GREEN_YELLOW)

                var arrays := []
                arrays.resize(Mesh.ARRAY_MAX)
                arrays[Mesh.ARRAY_VERTEX] = PackedVector3Array(bvert)
                arrays[Mesh.ARRAY_COLOR] = PackedColorArray(colors)
                arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
                # mesh.surface_set_material(0, your_material)   # will need uvs if using a texture
                wallmat.vertex_color_use_as_albedo = true
                arr_mesh.surface_set_material(0, wallmat)
                nut.get_child(0).mesh = arr_mesh
                
                nut.get_child(1).position += Vector3(0.5, 0.5, 0.5)*MSF
    
    
    return levelroot


func get_all_file_paths(path: String) -> Array[String]:  
    var file_paths: Array[String] = []  
    var dir = DirAccess.open(path)  
    dir.list_dir_begin()  
    var file_name = dir.get_next()  
    while file_name != "":
        var file_path = path + "/" + file_name  
        if dir.current_is_dir():  
            file_paths += get_all_file_paths(file_path)  
        else:
            file_paths.append(file_path)  
        file_name = dir.get_next()  
    return file_paths

func load_layer():
    pass

func _ready() -> void:
    var e = get_all_file_paths("res://maps")
    
    for j in e:
        var cockywant = j.split("//")[-1].split("/").slice(1)
        if cockywant[-1].split('.')[-1] == 'import':
            continue
        
        if int(cockywant[0].split('_')[-1]) in levels:
            levels[int(cockywant[0].split('_')[-1])].append([j, cockywant])
        else:
            levels[int(cockywant[0].split('_')[-1])] = [[j, cockywant]]
    
    for ll in levels:
        var e11 = levels[ll]
        for jj in e11:
            jj.append(load_map(load(jj[0]).get_image(), mos, player_main))

    "Pirate software is a 
    fucking old head so he probably played doom? 
    Counterstrike my `friend` said yay up down looking, 
    this game =/= doom. So i rebute with PS (like piss) is an old head and fuck this"

    mo.add_child(load_map(load(levels[lidx][fidx][0]).get_image(), mos, player_main))
    eeeeeeeeeeee.text = "LEvel: %d, Floor: %d" % [lidx, fidx]
    pass


func _on_collision_shape_3d_woah() -> void:
    if lidx == 10:
        get_parent().get_parent().add_child(escene)
        get_parent().hide()
        
    for i in mo.get_children():
        mo.remove_child(i)
    # if p == "lend":
    if lidx == 7:
        lidx += 2
    else:
        lidx += 1

    #if fidx+1 == len(levels[lidx]):
        #lidx += 1
        #fidx = 0
        ## Do next level screen
    #else:
        #fidx += 1
    mo.add_child(load_map(load(levels[lidx][0][0]).get_image(), mos, player_main))
    eeeeeeeeeeee.text = "LEvel: %d, Floor: %d" % [lidx, fidx]

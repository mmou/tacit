gd = 1.65

window.sign = ->
    structure = new tacit.Structure
    new structure.Node({x:20, y:gd})
    new structure.Node({x:60, y:gd})
    new structure.Beam({x:47, y:72}, {x:47, y:97})
    structure.nodeList[i].fixed.y = true for i in [0,1]
    structure.nodeList[i].fixed.x = true for i in [0,1]
    structure.nodeList[2].force.x = 50
    structure.nodeList[3].force.x = 50
    node.immovable = true for node in structure.nodeList
    return structure


window.bridge = ->
    hg = 50

    structure = new tacit.Structure

    new structure.Node({x:0, y:gd})
    new structure.Node({x:200, y:gd})
    structure.nodeList[i].fixed.y = true for i in [0,1]
    structure.nodeList[i].fixed.x = true for i in [0,1]
    new structure.Beam({x:0, y:gd}, {x:67, y:gd})
    new structure.Beam({x:67, y:gd}, {x:133, y:gd})
    new structure.Beam({x:133, y:gd}, {x:200, y:gd})
    # new structure.Beam({x:2, y:gd}, {x:200, y:gd})
    structure.nodeList[2].force.y = -158
    structure.nodeList[3].force.y = -158
    node.immovable = true for node in structure.nodeList
    return structure

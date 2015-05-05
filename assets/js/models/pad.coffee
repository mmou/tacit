@tacit ?= {}

class Pad
    constructor: (@easel, @htmlLoc, @height, @width, structure) ->
        gd = 1.75
        if not structure?
            structure = new tacit.Structure
            new structure.Beam({x: 20, y: gd}, {x: 70, y: 30})
            new structure.Beam({x: 70, y: 30}, {x: 80, y: gd})
            new structure.Beam({x: 80, y: gd}, {x: 40, y: 30})
            new structure.Beam({x: 40, y: 30}, {x: 20, y: gd})
            new structure.Beam({x: 40, y: 30}, {x: 70, y: 30})
            new structure.Beam({x: 20, y: gd}, {x: 25, y: 40})
            new structure.Beam({x: 25, y: 40}, {x:  0, y: 90})
            new structure.Beam({x:  0, y: 90}, {x: 20, y: gd})
            new structure.Beam({x: 25, y: 40}, {x: 40, y: 30})
            structure.nodeList[i].fixed.y = true for i in [0,2]
            structure.nodeList[i].fixed.x = true for i in [0]
            structure.nodeList[1].force.y = -75
            structure.nodeList[3].force.y = -50
            structure.nodeList[4].force[dim] = -30 for dim in "xy"
            structure.nodeList[5].force[dim] = -15 for dim in "xy"
        @sketch = new tacit.Sketch(this, @htmlLoc, structure, @height, @width)

    load: (structure) ->
        @sketch.svg.remove()
        translate = [@sketch.translate[0]*@sketch.scale,
                     @sketch.translate[1]*@sketch.scale]
        scale = @sketch.scale
        console.log "before"
        console.log translate
        console.log scale
        @sketch = new tacit.Sketch(this, @htmlLoc, structure, @height, @width)
        console.log "after"
        console.log @sketch.translate
        console.log @sketch.scale
        console.log "-----"

@tacit.Pad = Pad

@tacit ?= {}

class Pad
    constructor: (@easel, @htmlLoc, @height, @width, structure) ->
        if not structure?
            structure = new tacit.Structure
            new structure.Beam({x: 10, y: 0}, {x: 30, y: 40})
            new structure.Beam({x: 30, y: 40}, {x: 80, y: 0})
            new structure.Beam({x: 10, y: 0}, {x: -5, y: 110})
            new structure.Beam({x: -5, y: 110}, {x: 30, y: 40})
            new structure.Beam({x: 30, y: 40}, {x: 100, y: 40})
            new structure.Beam({x: 100, y: 40}, {x: 80, y: 0})
            new structure.Beam({x: 10, y: 0}, {x: 100, y: 40})
            structure.nodeList[i].fixed.y = true for i in [0,2]
            structure.nodeList[i].fixed.x = true for i in [0]
            structure.nodeList[i].force[dim] = -100 for i in [1,3,4] for dim in ["y"]
        @sketch = new tacit.Sketch(this, @htmlLoc, structure, @height, @width)

    load: (structure) ->
        @sketch.svg.remove()
        @sketch = new tacit.Sketch(this, @htmlLoc, structure, @height, @width)

@tacit.Pad = Pad

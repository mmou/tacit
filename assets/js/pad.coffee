@tacit ?= {}

class Pad
    constructor: (@easel, @htmlLoc, @height, @width, structure=null) ->
        if not structure?
            structure = new tacit.Structure
            new structure.Beam({x: 100, y: 100}, {x: 0, y: 0})
            new structure.Beam({x: 100, y: 100}, {x: 200, y: 0})
            structure.nodeList[0].force.y = -100
            structure.nodeList[i].fixed[dim] = true for i in [1,2] for dim in ["x", "y"]
        @sketch = new tacit.Sketch(this, @htmlLoc, structure, @height, @width)

    load: (structure) ->
        @sketch = new tacit.Sketch(this, @htmlLoc, structure, @height, @width)

@tacit.Pad = Pad

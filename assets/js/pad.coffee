class Pad
    constructor: (@easel, @htmlLoc, @height, @width, structure=null) ->
        if not structure?
            structure = new @tacit.Structure
            new structure.Beam({x: 1, y: 1}, {x: 0, y: 0})
            new structure.Beam({x: 1, y: 1}, {x: 2, y: 0})
            structure.nodeList[0].force.y = -1
            structure.nodeList[i].fixed[dim] = true for i in [1,2] for dim in ["x", "y"]
        @sketch = new Sketch(this, @htmlLoc, structure, @height, @width)

    load: (structure) ->
        @sketch = new Sketch(this, @htmlLoc, structure, @height, @width)

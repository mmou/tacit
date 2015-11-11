@tacit ?= {}

class Pad
    constructor: (@easel, @htmlLoc, @height, @width, structure) ->
        @sketch = new tacit.Sketch(this, @htmlLoc, structure, @height, @width)

    load: (structure) ->
        @sketch.svg.remove()
        translate = [@sketch.translate[0]*@sketch.scale,
                     @sketch.translate[1]*@sketch.scale]
        scale = @sketch.scale
        @sketch = new tacit.Sketch(this, @htmlLoc, structure, @height, @width)

@tacit.Pad = Pad

@tacit ?= {}

class Pad
    constructor: (@easel, @htmlLoc, @height, @width, structure) ->
        @sketch = new tacit.Sketch(this, @htmlLoc, structure, @height, @width)

    load: (structure, genhelper=true) ->
        @sketch.svg.remove()
        translate = [@sketch.translate[0]*@sketch.scale,
                     @sketch.translate[1]*@sketch.scale]
        scale = @sketch.scale
        @sketch = new tacit.Sketch(this, @htmlLoc, structure, @height, @width)
        if genhelper and window.genhelper? then window.genhelper()

@tacit.Pad = Pad

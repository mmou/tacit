window.tacit ?= {}
window.tacit.tools ?= {}

sqr = (a) -> Math.pow(a, 2)
abs = (a) -> Math.abs(a)
sqrt = (a) -> Math.sqrt(a)
max = (n...) -> Math.max(n...)
sin = (a) -> Math.sin(a)
atan2 = (a,b) -> Math.atan2(a,b)

moveTool =
    allowPan: true
    name: "move"

    mouseDown: (easel, eventType, mouseLoc, object) ->
        if eventType is "node"
            if not object.immovable?
                @selection = object
                @selectiontype = "node"
                @allowPan = false
                @dragstart = true
                idx = easel.pad.sketch.selectedNodes.indexOf(object)
                easel.pad.sketch.selectedNodes.push(object) if idx is -1
                easel.pad.sketch.quickDraw()
        else if eventType is "beam"
            @selection = object
            @selectiontype = "beam"
            @allowPan = false
            @dragstart = {x: mouseLoc[0], y: mouseLoc[1], size:object.size}
            easel.pad.sketch.selectedLinks = [@selection]
            easel.pad.sketch.slowDraw()

    mouseUp: (easel, eventType, mouseLoc, object) ->
        if @selectiontype is "node"
            idx = easel.pad.sketch.selectedNodes.indexOf(@selection)
            easel.pad.sketch.selectedNodes.splice(idx, 1)
            easel.pad.sketch.quickDraw()
        else if @selectiontype is "beam"
            easel.pad.sketch.selectedLinks = []
            easel.pad.sketch.slowDraw()
        @selection = null
        @selectiontype = null
        @dragstart = null
        @allowPan = true

    mouseMove: (easel, eventType, mouseLoc, object) ->
        if @dragstart
            pos = {x: mouseLoc[0], y: mouseLoc[1]}
            if @selectiontype is "node"
                @selection.moveto(pos)
            else if @selectiontype is "beam"
                d_x = pos.x-@dragstart.x
                d_y = pos.y-@dragstart.y
                b_x = @selection.source.x - @selection.target.x
                b_y = @selection.source.y - @selection.target.y
                orthogonal = -(b_x*d_y - b_y*d_x)/@selection.L
                orthogonal *=  abs(orthogonal)/10
                if orthogonal < 0
                    orthogonal = orthogonal/2
                @selection.size = max(0.5, orthogonal + @dragstart.size)
            easel.pad.sketch.quickDraw()

window.tacit.tools.move = moveTool

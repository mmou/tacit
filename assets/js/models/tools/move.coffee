window.tacit ?= {}
window.tacit.tools ?= {}

sqr = (a) -> Math.pow(a, 2)
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
            @allowPan = true
        else if @selectiontype is "beam"
            easel.pad.sketch.selectedLinks = []
            easel.pad.sketch.slowDraw()
        @selection = null
        @selectiontype = null
        @dragstart = null

    mouseMove: (easel, eventType, mouseLoc, object) ->
        if @dragstart
            pos = {x: mouseLoc[0], y: mouseLoc[1]}
            if @selectiontype is "node"
                @selection.moveto(pos)
            else if @selectiontype is "beam"
                xdist = pos.x-@dragstart.x
                ydist = pos.y-@dragstart.y
                dist = sqrt(sqr(xdist) + sqr(ydist))
                sign = sin(atan2(ydist, xdist))
                @selection.size = max(0.5, sign*dist*1.4 + @dragstart.size)
            easel.pad.sketch.quickDraw()

window.tacit.tools.move = moveTool

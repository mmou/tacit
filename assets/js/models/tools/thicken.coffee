window.tacit ?= {}
window.tacit.tools ?= {}

sqr = (a) -> Math.pow(a, 2)
sqrt = (a) -> Math.sqrt(a)
max = (n...) -> Math.max(n...)
sin = (a) -> Math.sin(a)
atan2 = (a,b) -> Math.atan2(a,b)

thickenTool =
    selection: null
    dragstart: null
    name: "thicken"

    mouseDown: (easel, eventType, mouseLoc, object) ->
        if not @selection
            if eventType is "beam"
                @selection = object
                @dragstart = {x: mouseLoc[0], y: mouseLoc[1], size:object.size}
                easel.pad.sketch.selectedLinks = [@selection]
                easel.pad.sketch.slowDraw()

    mouseUp: (easel, eventType, mouseLoc, object) ->
        @selection = null
        @dragstart = null
        easel.pad.sketch.selectedLinks = []
        easel.pad.sketch.slowDraw()

    mouseMove: (easel, eventType, mouseLoc, object) ->
        if @selection
            pos = {x: mouseLoc[0], y: mouseLoc[1]}
            xdist = pos.x-@dragstart.x
            ydist = pos.y-@dragstart.y
            dist = sqrt(sqr(xdist) + sqr(ydist))
            sign = sin(atan2(ydist, xdist))
            @selection.size = max(0.5, sign*dist*1.4 + @dragstart.size)
            easel.pad.sketch.quickDraw()


window.tacit.tools.thicken = thickenTool

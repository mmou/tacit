window.tacit ?= {}
window.tacit.tools ?= {}

moveTool =
    allowPan: true

    mouseDown: (easel, eventType, mouseLoc, object) ->
        @dragging = true
        if eventType is "node"
            @selection = object
            @allowPan = false
            idx = easel.pad.sketch.selectedNodes.indexOf(object)
            easel.pad.sketch.selectedNodes.push(object) if idx is -1
            easel.pad.sketch.quickDraw()

    mouseUp: (easel, eventType, mouseLoc, object) ->
        @dragging = false
        if @selection
            idx = easel.pad.sketch.selectedNodes.indexOf(@selection)
            easel.pad.sketch.selectedNodes.splice(idx, 1)
            easel.pad.sketch.quickDraw()
            @selection = null
            @allowPan = true

    mouseMove: (easel, eventType, mouseLoc, object) ->
        if @dragging and @selection
            @selection.moveto({x: mouseLoc[0], y: mouseLoc[1]})
            easel.pad.sketch.quickDraw()


window.tacit.tools.move = moveTool

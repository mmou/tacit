window.tacit ?= {}
window.tacit.tools ?= {}

loadTool =

    mouseDown: (easel, eventType, mouseLoc, object) ->
        @dragging = true
        if eventType is "node" or eventType is "force"
            @selection = object
            @allowPan = false
            idx = easel.pad.sketch.selectedNodes.indexOf(object)
            easel.pad.sketch.selectedNodes.push(object) if idx is -1
            easel.pad.sketch.quickDraw()

    mouseUp: (easel, eventType, mouseLoc, object) ->
        @dragging = false
        if @selection
            if object is @selection and eventType is "node"
                @selection.force.x = 0
                @selection.force.y = 0
            idx = easel.pad.sketch.selectedNodes.indexOf(@selection)
            easel.pad.sketch.selectedNodes.splice(idx, 1)
            easel.pad.sketch.quickDraw()
            @selection = null

    mouseMove: (easel, eventType, mouseLoc, object) ->
        if @dragging and @selection
            @selection.force.x = 6*(mouseLoc[0] - @selection.x)
            @selection.force.y = 6*(mouseLoc[1] - @selection.y)
            easel.pad.sketch.quickDraw()


window.tacit.tools.load = loadTool

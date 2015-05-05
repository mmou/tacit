window.tacit ?= {}
window.tacit.tools ?= {}

moveTool =
    allowPan: true
    name: "move"

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
        else if not @dragging
            change = false
            if eventType is "node"
                if not 1 + easel.pad.sketch.selectedNodes.indexOf(object)
                    change = true
                    easel.pad.sketch.selectedNodes = [object]
            else if easel.pad.sketch.selectedNodes.length > 0
                change = true
                @selection = null
                easel.pad.sketch.selectedNodes = []

            if change and object isnt @selection
                if eventType is "node"
                    easel.project.onChange()
                    @selection = object
                easel.pad.sketch.animateSelection()



window.tacit.tools.move = moveTool

window.tacit ?= {}
window.tacit.tools ?= {}

selectTool =
    name: "select"

    mouseDown: (easel, eventType, mouseLoc, object) ->
        @dragging = true

        if eventType isnt "background"
            if eventType is "node"
                selection = easel.pad.sketch.selectedNodes
            else
                selection = easel.pad.sketch.selectedLinks

            idx = selection.indexOf(object)
            if idx is -1
                selection.push(object)
            else
                selection.splice(idx, 1)

            if eventType is "node"
                easel.pad.sketch.selectedNodes = selection
            else
                easel.pad.sketch.selectedLinks = selection

            easel.pad.sketch.resize()

    mouseUp: (easel, eventType, mouseLoc, object) ->
        @dragging = false

    mouseMove: (easel, eventType, mouseLoc, object) ->
        if @dragging
            if eventType isnt "background"
                if eventType is "node"
                    selection = easel.pad.sketch.selectedNodes
                else
                    selection = easel.pad.sketch.selectedLinks

                idx = selection.indexOf(object)
                if idx is -1
                    selection.push(object)

                if eventType is "node"
                    easel.pad.sketch.selectedNodes = selection
                else
                    easel.pad.sketch.selectedLinks = selection

                easel.pad.sketch.resize()


window.tacit.tools.select = selectTool

window.tacit ?= {}
window.tacit.tools ?= {}

eraseTool =
    allowPan: true
    name: "erase"

    mouseDown: (easel, eventType, mouseLoc, object) ->
        @allowPan = false
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

            easel.pad.sketch.slowDraw()

    mouseUp: (easel, eventType, mouseLoc, object) ->
        @allowPan = true
        @dragging = false
        node.delete() for node in easel.pad.sketch.selectedNodes
        link.delete() for link in easel.pad.sketch.selectedLinks
        easel.pad.sketch.selectedLinks = []
        easel.pad.sketch.selectedNodes = []
        easel.pad.sketch.updateDrawing()

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

                easel.pad.sketch.quickDraw()


window.tacit.tools.erase = eraseTool

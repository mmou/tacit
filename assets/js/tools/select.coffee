@tacit ?= {}
@tacit.tools ?= {}

selectTool =
    mouseDown: (easel, eventType, mouseLoc, object) ->
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

            console.log selection

            if eventType is "node"
                easel.pad.sketch.selectedNodes = selection
            else
                easel.pad.sketch.selectedLinks = selection

            easel.pad.sketch.reposition_transition()

@tacit.tools.select = selectTool

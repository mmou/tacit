selectTool =
    mouseDown: (easel, eventType, mouseLoc, object) ->
        d3.mouse
        if eventType is "node"
            selectedNodes = easel.pad.sketch.selectedNodes
            idx = selectedNodes.indexOf(object)
            if idx is -1
                selectedNodes.push(object)
            else
                before = selectedNodes.slice(0,idx)
                after = selectedNodes(idx+1)
                easel.pad.sketch.selectedNodes = before.concat(after)

    mouseUp: (easel, eventType, mouseLoc, object) -> null
    mouseMove: (easel, eventType, mouseLoc, object) -> null

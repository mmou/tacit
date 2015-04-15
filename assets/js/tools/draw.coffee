window.tacit ?= {}
window.tacit.tools ?= {}

drawTool =
    drawStart: null

    mouseDown: (easel, eventType, mouseLoc, object) ->
        if not @drawStart
            if eventType isnt "node"
                pos = {x: mouseLoc[0], y: mouseLoc[1]}
                node = new easel.pad.sketch.structure.Node(pos)
                node.force.y = -100
                easel.pad.sketch.updateDrawing()
            else
                pos = {x: object.x, y: object.y}
            @drawStart = pos
            easel.pad.sketch.dragline
                            .attr("x1", pos.x).attr("x2", pos.x)
                            .attr("y1", pos.y).attr("y2", pos.y)

    mouseUp: (easel, eventType, mouseLoc, object) ->
        if @drawStart
            if eventType isnt "node"
                pos = {x: mouseLoc[0], y: mouseLoc[1]}
                node = new easel.pad.sketch.structure.Node(pos)
                node.force.y = -100
            else
                pos = {x: object.x, y: object.y}
            if pos.x isnt @drawStart.x and pos.y isnt @drawStart.y
                new easel.pad.sketch.structure.Beam(@drawStart, pos)
                easel.pad.sketch.dragline
                                .attr("x1", pos.x).attr("x2", pos.x)
                                .attr("y1", pos.y).attr("y2", pos.y)
                easel.pad.sketch.updateDrawing()
                @drawStart = null

    mouseMove: (easel, eventType, mouseLoc, object) ->
        if @drawStart
            easel.pad.sketch.dragline
                            .attr("x2", mouseLoc[0])
                            .attr("y2", mouseLoc[1])
            easel.pad.sketch.quickDraw()

window.tacit.tools.draw = drawTool

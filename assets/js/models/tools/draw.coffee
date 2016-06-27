window.tacit ?= {}
window.tacit.tools ?= {}

drawTool =
    drawStart: null
    allowPan: true
    name: "draw"

    mouseDown: (easel, eventType, mouseLoc, object) ->
        @allowPan = false
        if not @drawStart
            if eventType is "beam"
                pos = {x: mouseLoc[0], y: mouseLoc[1]}
                new easel.pad.sketch.structure.Beam(pos, object.source)
                new easel.pad.sketch.structure.Beam(pos, object.target)
                object.delete()
                easel.pad.sketch.updateDrawing()
            else if eventType isnt "node"
                pos = {x: mouseLoc[0], y: mouseLoc[1]}
                node = new easel.pad.sketch.structure.Node(pos)
                # node.force.y = -100
                easel.pad.sketch.updateDrawing()
            else
                pos = {x: object.x, y: object.y}
            @drawStart = pos
            easel.pad.sketch.dragline
                            .attr("x1", pos.x).attr("x2", pos.x)
                            .attr("y1", pos.y).attr("y2", pos.y)

    mouseUp: (easel, eventType, mouseLoc, object) ->
        @allowPan = true
        if @drawStart
            if eventType is "beam"
                pos = {x: mouseLoc[0], y: mouseLoc[1]}
                new easel.pad.sketch.structure.Beam(pos, object.source)
                new easel.pad.sketch.structure.Beam(pos, object.target)
                object.delete()
            else if eventType isnt "node"
                pos = {x: mouseLoc[0], y: mouseLoc[1]}
                node = new easel.pad.sketch.structure.Node(pos)
                # node.force.y = -100
            else
                pos = {x: object.x, y: object.y}
            if pos.x isnt @drawStart.x or pos.y isnt @drawStart.y
                new easel.pad.sketch.structure.Beam(@drawStart, pos)
                easel.pad.sketch.dragline
                                .attr("x1", pos.x).attr("x2", pos.x)
                                .attr("y1", pos.y).attr("y2", pos.y)
                easel.pad.sketch.updateDrawing()
                @drawStart = null
                if window.tutorial_state is 6 or window.tutorial_state is 7
                    window.advance_tutorial()

    mouseMove: (easel, eventType, mouseLoc, object) ->
        if @drawStart
            easel.pad.sketch.dragline
                            .attr("x2", mouseLoc[0])
                            .attr("y2", mouseLoc[1])
            easel.pad.sketch.quickDraw()

    stopDrawing: (easel) ->
        easel.pad.sketch.dragline
                        .attr("x1", 0).attr("x2", 0)
                        .attr("y1", 0).attr("y2", 0)
        easel.pad.sketch.updateDrawing()
        @drawStart = null


window.tacit.tools.draw = drawTool

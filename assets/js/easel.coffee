print = (o) -> console.log(o)
dist = (a, b) -> sqrt(sum(sqr(ai-(if b then b[i] else 0)) for ai, i in a))

@tacit ?= {}

class Easel
    constructor: (@project, toolbarLoc, padLoc, padHeight, padWidth, structure=null) ->
        #@toolbar = new tacit.Toolbar(this, toolbarLoc)

        padHtmlRect = d3.select(padLoc).node().getBoundingClientRect()
        padWidth ?= htmlRect.width
        padHeight ?= htmlRect.height
        @pad = new tacit.Pad(this, padLoc, padHeight, padWidth, structure)

    currentTool:
        mouseDown: (easel, eventType, mouseLoc, object) ->
            if eventType isnt "node"
                pos = {x: mouseLoc[0], y: mouseLoc[1]}
                node = new easel.pad.sketch.structure.Node(pos)
                node.force.y = -1
                easel.pad.sketch.redraw()
            else
                pos = {x: object.x, y: object.y}
            easel.pad.sketch.dragline
                            .attr("x1", pos.x).attr("x2", pos.x)
                            .attr("y1", pos.y).attr("y2", pos.y)
            easel.currentTool.dragStart = pos

        mouseUp: (easel, eventType, mouseLoc, object) ->
            if eventType isnt "node"
                pos = {x: mouseLoc[0], y: mouseLoc[1]}
                node = new easel.pad.sketch.structure.Node(pos)
                node.force.y = -1
            else
                pos = {x: object.x, y: object.y}
            if pos isnt easel.currentTool.dragStart
                new easel.pad.sketch.structure.Beam(easel.currentTool.dragStart, pos)
                easel.pad.sketch.dragline
                                .attr("x1", pos.x).attr("x2", pos.x)
                                .attr("y1", pos.y).attr("y2", pos.y)
                easel.pad.sketch.redraw()
            easel.currentTool.dragStart = null

        mouseMove: (easel, eventType, mouseLoc, object) ->
            if easel.currentTool.dragStart
                easel.pad.sketch.dragline
                                .attr("x2", mouseLoc[0])
                                .attr("y2", mouseLoc[1])
                if easel.pad.sketch.reposition?
                    easel.pad.sketch.reposition()

@tacit.Easel = Easel

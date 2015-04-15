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
        drawStart: null

        mouseDown: (easel, eventType, mouseLoc, object) ->
            if not @drawStart
                if eventType isnt "node"
                    pos = {x: mouseLoc[0], y: mouseLoc[1]}
                    node = new easel.pad.sketch.structure.Node(pos)
                    node.force.y = -100
                    easel.pad.sketch.redraw()
                else
                    pos = {x: object.x, y: object.y}
                @drawStart = pos
                easel.pad.sketch.dragline
                                .attr("x1", pos.x).attr("x2", pos.x)
                                .attr("y1", pos.y).attr("y2", pos.y)

        mouseUp: (easel, eventType, mouseLoc, object) ->
            print ["mU", object]
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
                    easel.pad.sketch.redraw()
                    @drawStart = null

        mouseMove: (easel, eventType, mouseLoc, object) ->
            if @drawStart
                easel.pad.sketch.dragline
                                .attr("x2", mouseLoc[0])
                                .attr("y2", mouseLoc[1])
                if easel.pad.sketch.reposition?
                    easel.pad.sketch.reposition()

@tacit.Easel = Easel

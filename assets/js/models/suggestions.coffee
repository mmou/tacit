window.tacit ?= {}

r = -> 2*Math.random() - 1

dummyEasel =
    mouseDown: (easel, eventType, mouseLoc, object) ->
        if @currentTool?
            if @currentTool.mouseDown?
                @currentTool.mouseDown(easel, eventType, mouseLoc, object)
        return false
    mouseUp: (easel, eventType, mouseLoc, object) ->
        if @currentTool?
            if @currentTool.mouseUp?
                @currentTool.mouseUp(easel, eventType, mouseLoc, object)
        return false
    mouseMove: (easel, eventType, mouseLoc, object) ->
        if @currentTool?
            if @currentTool.mouseMove?
                @currentTool.mouseMove(easel, eventType, mouseLoc, object)
        return false

class Suggestions
    constructor: (@project, @htmlLoc) ->
        @project.easel.pad.sketch.onChange = =>
            @update(@project.easel.pad.sketch.structure)

        structure = new tacit.Structure(@project.easel.pad.sketch.structure)
        @pads = []
        for i in [1..4]
            @pads.push(new tacit.Pad(dummyEasel, @htmlLoc, 200, 225, structure))
        @update(structure)


    mutate: (structure) ->
        for node in structure.nodeList
            dg = 200*r()*structure.nodeList.length/structure.lp.obj
            delta =
                x: node.grad.x*dg * not node.fixed.x
                y: node.grad.y*dg * not node.fixed.y
                z: node.grad.z*dg * not node.fixed.z
            node.move(delta)

    update: (structure) ->
        for pad, i in @pads
            structure = new tacit.Structure(structure)
            structure.solve()
            @mutate(structure)
            pad.load(structure)
            pad.sketch.nodeSize = 0
            pad.sketch.showforce = false
            pad.sketch.updateDrawing()
            pad.sketch.svg.on("mousedown", (d) =>
                console.log structure.lp.obj
                @project.easel.pad.load(structure)
                @project.easel.pad.sketch.onChange = =>
                    @update(@project.easel.pad.sketch.structure)
                @project.easel.pad.sketch.updateDrawing())


window.tacit.Suggestions = Suggestions
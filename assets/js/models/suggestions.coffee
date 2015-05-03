window.tacit ?= {}

r = -> 2*Math.random() - 1

class dummyEasel
    constructor: (@suggestions, @i) -> null

    mouseDown: (easel, eventType, mouseLoc, object) ->
        console.log @i
        @suggestions.project.easel.pad.load(@suggestions.pads[@i].sketch.structure)
        @suggestions.project.easel.pad.sketch.onChange = =>
            @suggestions.update(@suggestions.project.easel.pad.sketch.structure)
        @suggestions.project.easel.pad.sketch.updateDrawing()
        return false

    mouseUp: (easel, eventType, mouseLoc, object) -> false
    mouseMove: (easel, eventType, mouseLoc, object) -> false

class Suggestions
    constructor: (@project, @htmlLoc) ->
        @project.easel.pad.sketch.onChange = =>
            @update(@project.easel.pad.sketch.structure)

        structure = new tacit.Structure(@project.easel.pad.sketch.structure)
        @pads = []
        for i in [1..3]
            @pads.push(new tacit.Pad(new dummyEasel(this, i), @htmlLoc, 200, 200, structure))
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
        for pad in @pads
            structure = new tacit.Structure(structure)
            structure.solve()
            @mutate(structure)
            pad.load(structure)
            pad.sketch.nodeSize = 0
            pad.sketch.showforce = false
            pad.sketch.updateDrawing()


window.tacit.Suggestions = Suggestions

window.tacit ?= {}

r = -> 2*Math.random() - 1

class dummyEasel
    constructor: (@suggestions, @i) -> null

    mouseDown: (easel, eventType, mouseLoc, object) ->
        console.log @i
        pad = @suggestions.pads[@i]
        drawpad = @suggestions.project.easel.pad
        scale = Math.min(pad.height/drawpad.height,
                         pad.width/drawpad.width)
        @suggestions.project.easel.pad.load(pad.sketch.structure,
                                            scale=pad.sketch.scale/scale)
        @suggestions.project.easel.pad.sketch.onChange = =>
            @suggestions.update(@suggestions.project.easel.pad.sketch.structure)
        @suggestions.project.easel.pad.sketch.updateDrawing()
        undoredo.log()

        return false


    allowPan: -> false
    mouseUp: (easel, eventType, mouseLoc, object) -> false
    mouseMove: (easel, eventType, mouseLoc, object) -> false

class Suggestions
    constructor: (@project, @htmlLoc) ->
        @project.onChange = =>
            @update(@project.easel.pad.sketch.structure)

        structure = new tacit.Structure(@project.easel.pad.sketch.structure)
        @pads = []
        for i in [0..2]
            @pads.push(new tacit.Pad(new dummyEasel(this, i), @htmlLoc, 180, 180, structure))
        @update(structure)


    mutate: (structure) ->
        for node in structure.nodeList
            dg = 200*r()*structure.nodeList.length/structure.lp.obj
            delta =
                x: (node.fgrad.x*dg + (r()+1)*node.grad.x*1000) * not node.fixed.x
                y: (node.fgrad.y*dg + (r()+1)*node.grad.y*1000) * not node.fixed.y
                z: (node.fgrad.z*dg + (r()+1)*node.grad.z*1000) * not node.fixed.z
            node.move(delta)

    update: (structure) ->
        drawpad = @project.easel.pad
        for pad in @pads
            structure = new tacit.Structure(structure)
            structure.solve()
            @mutate(structure)
            pad.load(structure)
            pad.sketch.nodeSize = 0
            pad.sketch.rect.attr("fill", "url(#grid)")
            pad.sketch.showforce = false
            scale = Math.min(pad.height/drawpad.height,
                             pad.width/drawpad.width)
            pad.sketch.rescale([drawpad.sketch.translate[0], drawpad.sketch.translate[1]],
                               scale*drawpad.sketch.scale, draw=false)
            pad.sketch.updateDrawing()


window.tacit.Suggestions = Suggestions

window.tacit ?= {}

class dummyEasel
    constructor: (@versions, @i) -> null

    mouseDown: (easel, eventType, mouseLoc, object) ->
        console.log @i
        @versions.project.easel.pad.load(@versions.history[@i].sketch.structure)
        @versions.project.easel.pad.sketch.onChange = =>
            suggestions.update(suggestions.project.easel.pad.sketch.structure)
        @versions.project.easel.pad.sketch.updateDrawing()
        return false

    mouseUp: (easel, eventType, mouseLoc, object) -> false
    mouseMove: (easel, eventType, mouseLoc, object) -> false

class Versions
    constructor: (@project, @htmlLoc) ->
        @history = []

    save: ->
        if @project.actionQueue.length > 1
            console.log("save")        
            structure = new tacit.Structure(@project.easel.pad.sketch.structure)
            structure.solve()
            pad = new tacit.Pad(new dummyEasel(this, @history.length), @htmlLoc, 60, 60, structure)         
            @history.push(pad)
            pad.load(structure)
            pad.sketch.nodeSize = 0
            pad.sketch.showforce = false
            pad.sketch.updateDrawing()

        @project.actionQueue = [@project.actionQueue[@project.actionQueue.length-1]]
        undoredo.pointer = 0

window.tacit.Versions = Versions

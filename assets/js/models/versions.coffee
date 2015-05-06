window.tacit ?= {}

class dummyEasel
    constructor: (@versions, @i) -> null

    mouseDown: (easel, eventType, mouseLoc, object) ->
        if window.tutorial_state is 2
            window.advance_tutorial()
        structure = new tacit.Structure(@versions.history[@i].sketch.structure)
        @versions.project.easel.pad.load(structure)
        @versions.project.easel.pad.sketch.updateDrawing()
        @versions.project.onChange()
        return false

    allowPan: -> false
    mouseUp: (easel, eventType, mouseLoc, object) -> false
    mouseMove: (easel, eventType, mouseLoc, object) -> false

class Versions
    constructor: (@project, @htmlLoc) ->
        @history = []
        @newVersion()

    newVersion: ->
        structure = new tacit.Structure(@project.easel.pad.sketch.structure)
        structure.solve()
        pad = new tacit.Pad(new dummyEasel(this, @history.length), @htmlLoc, 60, 60, structure)
        pad.load(structure)
        pad.sketch.nodeSize = 0
        pad.sketch.showforce = false
        pad.sketch.updateDrawing()
        @history.push(pad)

    save: ->
        if @project.actionQueue.length > 1
            @newVersion()
        @project.actionQueue = [@project.actionQueue[@project.actionQueue.length-1]]
        undoredo.pointer = 0

window.tacit.Versions = Versions

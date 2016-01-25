window.tacit ?= {}

class dummyEasel
    constructor: (@versions, @i) -> null

    mouseDown: (easel, eventType, mouseLoc, object) ->
        if window.tutorial_state is 2 or window.tutorial_state is 8
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
        versionObj = d3.select(@htmlLoc).append("li").attr("id", "ver"+@history.length)
        easel = new dummyEasel(this, @history.length)
        easel.weightDisplay = versionObj.append("span")[0][0]
        pad = new tacit.Pad(easel, "#ver"+@history.length,
                            50, 50, structure)
        pad.load(structure)
        pad.sketch.nodeSize = 0
        pad.sketch.showforce = false
        pad.sketch.updateDrawing()
        @history.push(pad)

    save: ->
        if @project.actionQueue.length > 1
            @newVersion()
        currently_at = @project.actionQueue[undoredo.pointer]
        structure = new tacit.Structure(currently_at)
        structure.solve()
        @project.actionQueue = [structure]
        undoredo.pointer = 0

window.tacit.Versions = Versions

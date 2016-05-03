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
        window.log += "\n# loaded structure\n" + structure.strucstr
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
        versionObj = d3.select(@htmlLoc).append("div").attr("id", "ver"+@history.length).classed("ver", true)
        easel = new dummyEasel(this, @history.length)
        versionObj.append("div").attr("id", "versvg"+@history.length).classed("versvg", true)
        easel.weightDisplay = versionObj.append("div").classed("verwd", true)[0][0]
        pad = new tacit.Pad(easel, "#versvg"+@history.length,
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
        window.log += "\n# saved"

window.tacit.Versions = Versions

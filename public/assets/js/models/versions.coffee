window.tacit ?= {}

class dummyEasel
    constructor: (@versions, @i, @project) -> null

    mouseDown: (easel, eventType, mouseLoc, object) ->
        if window.triggers.load?
            window.triggers.load()
        structure = new tacit.Structure(@versions.history[@i].sketch.structure)
        structure.solve()
        @project.actionQueue = [structure]
        undoredo.pointer = 0
        structure = new tacit.Structure(structure)
        @versions.project.easel.pad.load(structure)
        @versions.project.easel.pad.sketch.feapad = window.feapadpad
        @versions.project.easel.pad.sketch.updateDrawing()
        @versions.project.easel.pad.sketch.fea()
        @versions.project.onChange()
        window.log += "# at #{new Date().toLocaleString()}, a new structure of weight #{structure.lp.obj} with #{project.easel.pad.sketch.structure.nodeList.length} nodes and #{project.easel.pad.sketch.structure.beamList.length} beams was created by the load tool\n" + structure.strucstr + "\n"
        return false

    allowPan: -> false
    mouseUp: (easel, eventType, mouseLoc, object) -> false
    mouseMove: (easel, eventType, mouseLoc, object) -> false

class Versions
    constructor: (@project, @htmlLoc) ->
        @history = []
        @newVersion()

    newVersion: (structure) ->
        if not structure?
            structure = new tacit.Structure(@project.easel.pad.sketch.structure)
        window.log ?= ""
        window.log += "# saved at #{new Date().toLocaleString()} \n"
        firebase.database().ref('events/').push().set
            tool: "save"
            timestamp: new Date().toLocaleString()
        @project.easel.pad.sketch.fea()
        versionObj = d3.select(@htmlLoc).append("div").attr("id", "ver"+@history.length).classed("ver", true)
        easel = new dummyEasel(this, @history.length, @project)
        versionObj.append("div").attr("id", "versvg"+@history.length).classed("versvg", true)
        easel.weightDisplay = versionObj.append("div").classed("verwd", true)[0][0]
        pad = new tacit.Pad(easel, "#versvg"+@history.length, 50, 50, structure)
        pad.load(structure, genhelper=false)
        pad.sketch.nodeSize = 0
        pad.sketch.showforce = false
        pad.sketch.updateDrawing()
        @history.push(pad)
        pad.sketch.fea()
        saved = Math.round(pad.sketch.structure.lp.obj/100)
        if saved <= $("#bestweight").text().substr(1)
            $("#bestweight").text("$"+saved)
            $("#bestcontainer").css("display", "")
            if window.triggers.beat?
                window.triggers.beat()

    save: (structure) ->
        if window.triggers.save?
            window.triggers.save()
        if @project.actionQueue.length > 1 or structure?
            @newVersion(structure)

window.tacit.Versions = Versions

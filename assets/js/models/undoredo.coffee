window.tacit ?= {}

class UndoRedo
    constructor: (@project) ->
        @pointer = -1
        @project.actionQueue ?= []
        @log()

    log: ->
        @project.onChange()
        structure = new tacit.Structure(@project.easel.pad.sketch.structure)
        structure.solve()

        if !@project.actionQueue[@pointer]? or @project.actionQueue[@pointer].strucstr != structure.strucstr
            window.log ?= ""
            window.log += "# at #{new Date().toLocaleString()}, a new structure of weight #{structure.lp.obj}\n" + structure.strucstr + "\n"
            @project.actionQueue = @project.actionQueue.slice(0,@pointer+1)
            @project.actionQueue.push(structure)
            @pointer = @project.actionQueue.length-1


    undo: ->
        if @pointer - 1 >= 0
            if window.triggers.undo?
                window.triggers.undo()
            window.log += "\n# undo"
            @pointer -= 1
            structure = new tacit.Structure(@project.actionQueue[@pointer])
            @project.easel.pad.load(structure)
            @project.easel.pad.sketch.feapad = window.feapadpad
            @project.easel.pad.sketch.updateDrawing()
            @project.easel.pad.sketch.dragline.attr("x1", 0).attr("x2", 0)
                                              .attr("y1", 0).attr("y2", 0)
            @project.easel.currentTool.drawStart = false

    redo: ->
        if @pointer + 1 < @project.actionQueue.length
            window.log += "\n# redo"
            @pointer += 1
            @project.easel.pad.load(@project.actionQueue[@pointer])
            @project.easel.pad.sketch.feapad = window.feapadpad
            @project.easel.pad.sketch.updateDrawing()

window.tacit.UndoRedo = UndoRedo

window.tacit ?= {}

class UndoRedo
    constructor: (@project) ->
        @pointer = -1
        @project.actionQueue ?= []
        @log()

    log: ->
        @project.onChange()
        @project.actionQueue = @project.actionQueue.slice(0,@pointer+1)

        structure = new tacit.Structure(@project.easel.pad.sketch.structure)
        structure.solve()
        if !@project.actionQueue[@pointer]? || @project.actionQueue[@pointer].LPstring() != structure.LPstring()
            @project.actionQueue.push(structure)
        @pointer = @project.actionQueue.length-1


    undo: ->
        if @pointer - 1 >= 0
            @pointer -= 1
            @project.easel.pad.load(@project.actionQueue[@pointer])
            @project.easel.pad.sketch.updateDrawing()

    redo: ->
        if @pointer + 1 < @project.actionQueue.length
            @pointer += 1
            @project.easel.pad.load(@project.actionQueue[@pointer])
            @project.easel.pad.sketch.updateDrawing()

window.tacit.UndoRedo = UndoRedo

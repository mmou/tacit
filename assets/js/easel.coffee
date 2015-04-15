@tacit ?= {}

class Easel
    constructor: (@project, toolbarLoc, padLoc, padHeight, padWidth, structure=null) ->
        #@toolbar = new tacit.Toolbar(this, toolbarLoc)

        padHtmlRect = d3.select(padLoc).node().getBoundingClientRect()
        padWidth ?= htmlRect.width
        padHeight ?= htmlRect.height
        @pad = new tacit.Pad(this, padLoc, padHeight, padWidth, structure)

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
        return false

    keyDown: (easel, eventType, keyCode) ->
        if @currentTool?
            if @currentTool.keyDown?
                @currentTool.keyDown(easel, eventType, keyCode)
                return false
        console.log ["kD", easel, eventType, keyCode]
        if keyCode is 8 or keyCode is 46  # backspace, delete
            for node in @pad.sketch.selectedNodes
                console.log node
                node.delete()
            link.delete() for link in @pad.sketch.selectedLinks
            @pad.sketch.selectedLinks = @pad.sketch.selectedNodes = []
            @pad.sketch.redraw()
        return false

@tacit.Easel = Easel

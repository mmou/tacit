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
        else
            false
    mouseUp: (easel, eventType, mouseLoc, object) ->
        if @currentTool?
            if @currentTool.mouseUp?
                @currentTool.mouseUp(easel, eventType, mouseLoc, object)
        else
            false
    mouseMove: (easel, eventType, mouseLoc, object) ->
        if @currentTool?
            if @currentTool.mouseMove?
                @currentTool.mouseMove(easel, eventType, mouseLoc, object)
        else
            false

    keyDown: (easel, eventType, mouseLoc, object) ->
        if @currentTool?
            if @currentTool.keyDown?
                @currentTool.keyDown(easel, eventType, mouseLoc, object)
        else
            print "kD"

@tacit.Easel = Easel

@tacit ?= {}

class Easel
    constructor: (@project, toolbarLoc, padLoc, padHeight, padWidth, structure=null) ->
        #@toolbar = new tacit.Toolbar(this, toolbarLoc)

        padHtmlRect = d3.select(padLoc).node().getBoundingClientRect()
        padWidth ?= htmlRect.width
        padHeight ?= htmlRect.height
        @pad = new tacit.Pad(this, padLoc, padHeight, padWidth, structure)

    currentTool:
            mouseDown: (easel, eventType, mouseLoc, object) -> false
            mouseUp: (easel, eventType, mouseLoc, object) -> false
            mouseMove: (easel, eventType, mouseLoc, object) -> false

@tacit.Easel = Easel

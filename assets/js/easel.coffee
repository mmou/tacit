class Easel
    constructor: (@project, toolbarLoc, padLoc, padHeight padWidth, structure=null) ->
        @toolbar = new Toolbar(this, toolbarLoc)

        padHtmlRect = d3.select(padLoc).node().getBoundingClientRect()
        padWidth ?= htmlRect.width
        padHeight ?= htmlRect.height
        @Pad = new Pad(this, padLoc, padHeight, padWidth, structure)

    currentTool:
        mouseDown: (easel, eventType, mouseLoc, object) -> null
        mouseUp: (easel, eventType, mouseLoc, object) -> null
        mouseMove: (easel, eventType, mouseLoc, object) -> null

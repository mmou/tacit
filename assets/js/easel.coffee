print = (o) -> console.log(o)

@tacit ?= {}

class Easel
    constructor: (@project, toolbarLoc, padLoc, padHeight, padWidth, structure=null) ->
        #@toolbar = new tacit.Toolbar(this, toolbarLoc)

        padHtmlRect = d3.select(padLoc).node().getBoundingClientRect()
        padWidth ?= htmlRect.width
        padHeight ?= htmlRect.height
        @pad = new tacit.Pad(this, padLoc, padHeight, padWidth, structure)

    currentTool:
        mouseDown: (easel, eventType, mouseLoc, object) ->
            print "mD"
            print [easel, eventType, mouseLoc, object]
        mouseUp: (easel, eventType, mouseLoc, object) ->
            print "mU"
            print [easel, eventType, mouseLoc, object]
        mouseMove: (easel, eventType, mouseLoc, object) ->
            print "mM"
            print [easel, eventType, mouseLoc, object]

@tacit.Easel = Easel

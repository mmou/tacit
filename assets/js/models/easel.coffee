window.tacit ?= {}

`
// from http://stackoverflow.com/questions/3665115/create-a-file-in-memory-for-user-to-download-not-through-server
function download(filename, text) {
  var pom = document.createElement('a');
  pom.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
  pom.setAttribute('download', filename);

  pom.style.display = 'none';
  document.body.appendChild(pom);

  pom.click();

  document.body.removeChild(pom);
}
`

class Easel
    constructor: (@project, toolbarLoc, padLoc, padHeight, padWidth, structure) ->
        #@toolbar = new tacit.Toolbar(this, toolbarLoc)

        padHtmlRect = d3.select(padLoc).node().getBoundingClientRect()
        padWidth ?= htmlRect.width
        padHeight ?= htmlRect.height
        @pad = new tacit.Pad(this, padLoc, padHeight, padWidth, structure)

    export: ->
        filename = if @project.name? then @project.name else "tacit"
        filename += ".svg"
        download(filename, d3.select(easel.pad.htmlLoc).html())

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

    keyDown: (easel, eventType, keyCode) ->
        if @currentTool?
            if @currentTool.keyDown?
                if @currentTool.keyDown(easel, eventType, keyCode)
                    return false
        switch d3.event.keyCode
            when 8, 46  # backspace, delete
                for node in @pad.sketch.selectedNodes
                    node.delete()
                link.delete() for link in @pad.sketch.selectedLinks
                @pad.sketch.selectedLinks = @pad.sketch.selectedNodes = []
                @pad.sketch.updateDrawing()
            when 68 # d
                easel.currentTool = tacit.tools.draw
                `$('.active').removeClass("active");
            	 $("#draw-btn").addClass("active");`
            when 83 # s
                easel.currentTool = tacit.tools.select
                `$('.active').removeClass("active");
            	 $("#select-btn").addClass("active");`
        return false

window.tacit.Easel = Easel

abs = (n) -> Math.abs(n)
min = (n...) -> Math.min(n...)
max = (n...) -> Math.max(n...)
pow = (n, p) -> Math.pow(n, p)
sqr = (n) -> Math.pow(n, 2)
sqrt = (n) -> Math.sqrt(n)
sum = (o) -> if o.length then o.reduce((a,b) -> a+b) else ""
dist = (a, b) -> sqrt(sum(sqr(ai - (if b then b[i] else 0)) for ai, i in a))
print = (o) -> console.log(o)

colormap = d3.scale.linear()
                    .domain([0, 0.166, 0.33, 0.5, 0.66, 0.83, (1-1e-6), 1, 2, 100])
            .range([d3.hsl("hsl(244, 100%, 39%)"), d3.hsl("hsl(214, 91%, 50%)"),
                    d3.hsl("hsl(186, 100%, 43%)"), d3.hsl("hsl(160, 84%, 50%)"),
                    d3.hsl("hsl(100, 100%, 50%)"), d3.hsl("hsl(60, 100%, 50%)"),
                    d3.hsl("hsl(33, 96%, 50%)"),
                    d3.hsl("hsl(0, 100%, 50%)"), d3.hsl("hsl(0, 100%, 30%)")
                    d3.hsl("hsl(0, 100%, 20%)"),])

window.tacit ?= {}
window.tacit.colormap = colormap

class dummyEasel
    constructor: (@versions, @i) -> null
    mouseDown: (easel, eventType, mouseLoc, object) -> false
    allowPan: -> false
    mouseUp: (easel, eventType, mouseLoc, object) -> false
    mouseMove: (easel, eventType, mouseLoc, object) -> false

class Sketch
    constructor: (@pad, htmlLoc="body", structure, @height, @width, scale, translate, feapad=true) ->
        @showforce = true
        @showzero = false
        @transitioning = false
        @drawscale = 5

        htmlObj = d3.select(htmlLoc)

        if structure?
            autozoom = true
            @structure = structure
        else
            autozoom = false
            @structure = new tacit.Structure

        @svg = htmlObj
                 .append("svg:svg")
                    .attr("width", @width)
                    .attr("height", @height)
                    .attr("pointer-events", "all")

        if autozoom and scale? and translate?
            autozoom = false

        @translate = [10,10]
        @scale = 0.00001
        @nodeSize = 9
        @easel = @pad.easel
        easel = @pad.easel  # for capture by mousedowns below

        @zoomer = d3.behavior.zoom().on("zoom", => @rescale() if easel.allowPan())
        mousedn = => @blank.call(d3.behavior.zoom().on("zoom"), => @rescale() if easel.allowPan())

        @selectedNodes = []
        @selectedLinks = []
        @blank = @svg.append("svg:g")
                     .attr("transform", "translate(0,#{height}) scale(1,-1)")
                     .append("svg:g")
                        .call(@zoomer)
                        .on("dblclick.zoom", null)
                        .append("svg:g")
                            .on("mousedown", mousedn)

        @background = @blank.append("svg:g")
                .on("mousedown", (d) -> easel.mouseDown(easel, "background", d3.mouse(this), d))
                .on("mousemove", (d) -> easel.mouseMove(easel, "background", d3.mouse(this), d))
                .on("mouseup",   (d) -> easel.mouseUp(easel, "background", d3.mouse(this), d))
        @rect = @background.append("svg:rect")
                             .attr("x", -@width / 2)
                             .attr("y", -@height / 2)
                             .attr("width", @width)
                             .attr("height", @height)
                             .attr("fill", "url(#grid)")
        @baseLine = @background.append("svg:line")
                                  .attr("x1", -200).attr("y1", 0)
                                  .attr("x2", 300).attr("y2", 0)
                                  .attr("stroke", "#3d3130")
                                  .attr("stroke-width", 0.5)


        if not window.keysCaptured
            d3.select(window).on("keydown", ->
                                 easel.keyDown(easel, "window", d3.event.keyCode))
            window.keysCaptured = true

        # init nodes,  links, and the line displayed when dragging new nodes
        @fixed = @blank.selectAll(".fixed")
        @nodes = @blank.selectAll(".node")
        @links = @blank.selectAll(".link")
        @selectablelinks = @blank.selectAll(".selectablelinks")
        @forces = @blank.selectAll(".force")
        @grads = @blank.selectAll(".grad")
        @dragline = @blank.append("line")
                          .attr("class", "dragline")
                          .attr("x1", 0).attr("x2", 0)
                          .attr("y1", 0).attr("y2", 0)

        # set inital window
        if autozoom?
            @defaultZoom()

        # Makes sketch always start out with gridLines
        gridBox = $('input[name=grid]')
        gridBox.prop('checked', true)
        baseLineBox = $('input[name=baseLine]')
        baseLineBox.prop('checked', true)
        if feapad and not window.feapad
            window.feapad = true
            deasel = new dummyEasel()
            @feapad = new tacit.Pad(deasel, "#FEAview", height, width, @structure, feapad=false)
            @feapad.showforce = false
            window.feapadpad = @feapad

    defaultZoom: ->
        window.scalemult ?= 0.6
        [mins, maxs, means] = [{}, {}, {}]
        for d in ["x", "y", "z"]
            list = (n[d] for n in @structure.nodeList)
            mins[d] = min(list...)
            maxs[d] = max(list...)
        scale = window.scalemult*min(@width/(maxs.x-mins.x), @height/(maxs.y-mins.y))
        translate = [@width/2 - scale*(maxs.x+mins.x)/2,
                     @height/2- scale*(maxs.y+mins.y)/2]
        @rescale(translate, scale)

    rescale: (translate, scale, draw=true, force=true) ->
        translate ?= d3.event.translate
        scale ?= d3.event.scale
        translate = [translate[0]/scale, translate[1]/scale]

        [mins, maxs, means] = [{}, {}, {}]
        for d in ["x", "y", "z"]
            list = (n[d] for n in @structure.nodeList)
            mins[d] = min(list...)
            maxs[d] = max(list...)

        outLeft = mins.x + translate[0] < -@translate[0]
        outBottom = mins.y + translate[1] < -@translate[1]
        outRight = maxs.x + translate[0] > 6/@scale*(@width/@scale - @translate[0]) #/
        outTop = maxs.y + translate[1] > 6/@scale*(@height/@scale - @translate[1]) #/

        if force or not (outLeft or outRight or outBottom or outTop)
            @rect.attr("x", -translate[0])
                 .attr("y", -translate[1])
                 .attr("width", @width/scale)
                 .attr("height", @height/scale)

            @scale = scale
            @translate = translate
            @blank.attr("transform", "scale(#{@scale}) translate(#{@translate})")
            if draw then @resize()
        if scale < @scale
            @scale = scale
            @blank.attr("transform", "scale(#{@scale}) translate(#{@translate})")
        @zoomer.translate([@translate[0]*@scale, @translate[1]*@scale])
        @zoomer.scale(@scale)

    updateDrawing: ->
        easel = @pad.easel

        @selectablelinks = @selectablelinks.data(@structure.beamList)
        @selectablelinks.enter().insert("line", ".node")
            .attr("class", "selectablelinks")
            .on("mousedown", (d) ->
                easel.mouseDown(easel, "beam", d3.mouse(this), d))
            .on("mousemove", (d) ->
                easel.mouseMove(easel, "beam", d3.mouse(this), d))
            .on("mouseup", (d) ->
                easel.mouseUp(easel, "beam", d3.mouse(this), d))
        @selectablelinks.exit().transition()
          .attr("r", 0)
        .remove()

        @links = @links.data(@structure.beamList)
        @links.enter().insert("line", ".node")
              .attr("class", "link")
              .attr("stroke", "#9c7b70")
              .on("mousedown", (d) ->
                  easel.mouseDown(easel, "beam", d3.mouse(this), d))
              .on("mousemove", (d) ->
                  easel.mouseMove(easel, "beam", d3.mouse(this), d))
              .on("mouseup", (d) ->
                  easel.mouseUp(easel, "beam", d3.mouse(this), d))
        @links.exit().transition()
            .attr("r", 0)
          .remove()

        @forces = @forces.data(@structure.nodeList)
        @forces.enter().insert("line")
            .attr("class", "force")
            .attr("stroke-width", 0)
            .attr("marker-end", "url(#brtriangle)")
            .on("mousedown", (d) ->
                easel.mouseDown(easel, "force", d3.mouse(this), d))
            .on("mousemove", (d) ->
                easel.mouseMove(easel, "force", d3.mouse(this), d))
            .on("mouseup", (d) ->
                easel.mouseUp(easel, "force", d3.mouse(this), d))
        @forces.exit().remove()

        @grads = @grads.data(@structure.nodeList)
        @grads.enter().insert("line")
            .attr("class","grad")
            .attr("stroke-width", 0)
            .attr("marker-end", "url(#ptriangle)")
            .on("mousedown", (d) ->
                easel.mouseDown(easel, "grad", d3.mouse(this), d))
            .on("mousemove", (d) ->
                easel.mouseMove(easel, "grad", d3.mouse(this), d))
            .on("mouseup", (d) ->
                easel.mouseUp(easel, "grad", d3.mouse(this), d))
        @grads.exit().remove()

        @nodes = @nodes.data(@structure.nodeList)
        @nodes.enter().insert("circle")
            .classed("node", true)
            .classed("fixed", (d) -> d.fixed.x or d.fixed.y)
            .classed("immovable", (d) -> d.immovable is true)
            .attr("r", @nodeSize/@scale/2)
            .on("mousedown", (d) ->
                easel.mouseDown(easel, "node", d3.mouse(this), d))
            .on("mousemove", (d) ->
                easel.mouseMove(easel, "node", d3.mouse(this), d))
            .on("mouseup", (d) ->
                easel.mouseUp(easel, "node", d3.mouse(this), d))
          .transition()
            .duration(80)
            .ease("elastic")
            .attr("r", @nodeSize/@scale)
        @nodes.exit().transition()
            .attr("r", 0)
          .remove()

        @fixed = @fixed.data(n for n in @structure.nodeList when n.fixed.x or n.fixed.y)
        @fixed.enter().insert("path")
                .attr("d", (d) -> "M #{-5+d.x},#{-3+d.y} l 5,8.6 l 5,-8.6 Z")
                .attr("class", "fixed")
                .on("mousedown", (d) ->
                    easel.mouseDown(easel, "node", d3.mouse(this), d))
                .on("mousemove", (d) ->
                    easel.mouseMove(easel, "node", d3.mouse(this), d))
                .on("mouseup", (d) ->
                    easel.mouseUp(easel, "node", d3.mouse(this), d))

        @slowDraw()

    fea: ->
        if @pad.easel.weightDisplay?
            cost = Math.round(@structure.lp.obj/100)
            if cost isnt 1000
                @pad.easel.weightDisplay.innerText = "\$"+cost
                if window.triggers.solve?
                    window.triggers.solve()
                if window.helper? then window.helper.attr("opacity", 0)
            else
                @pad.easel.weightDisplay.innerHTML = "$&infin;"
                if window.helper?
                    if not @structure.lp.undersized
                        window.helper.attr("opacity", 0.3)
                    else
                        window.helper.attr("opacity", 0)
        if @feapad?
            @feapad.load(@structure, genhelper=false)
            @feapad.sketch.updateDrawing()
            @feapad.sketch.fea()
            @links.attr("stroke", "#9c7b70")
                  .attr("stroke-dasharray", null)
            @feapad.sketch.defaultZoom()
        else
            if not window.tool.autocolor and @height > 100
                @showforce = false
                @rect.attr("fill", "rgba(255,255,255,1)")
                     .attr("stroke", "#2eabe2")
                @baseLine.attr("stroke", 0)
            @links.attr("stroke", (d) => if d.F > 1e-3 then colormap(d.F/d.size) else "#9c7b70")
                  .attr("stroke-dasharray", (d) => if d.F > 1e-3 then null else 10/@drawscale+","+10/@drawscale)

    slowDraw: ->
        @structure.solve()
        @structure.solvegrad(@selectedNodes)
        w = @structure.nodeList.length/@structure.lp.obj
        @fea() if window.tool.autocolor

        @dragline.attr("stroke-width", 10/@drawscale)
                 .attr("stroke-dasharray", 10/@drawscale+","+10/@drawscale)

        @links.attr("x1", (d) => d.source.x).attr("x2", (d) => d.target.x)
              .attr("y1", (d) => d.source.y).attr("y2", (d) => d.target.y)
              .transition()
                  .duration(80)
                  .ease("elastic")
                      .attr("stroke-opacity", (d) => 0.9 + 0.1*(@selectedLinks.indexOf(d)+1 > 0))
                .duration(80)
                .ease("elastic")
                    .attr("stroke-width",  (d) => if d.size > 1e-3 then  sqrt(d.size/10) else 1)

        @selectablelinks.attr("x1", (d) => d.source.x).attr("x2", (d) => d.target.x)
              .attr("y1", (d) => d.source.y).attr("y2", (d) => d.target.y)
              .classed("selected", (d) => @selectedLinks.indexOf(d)+1)
              .transition()
                .duration(80)
                .ease("elastic")
                    .attr("stroke-width",  (d) => max(2, 0.75 + sqrt(d.size/10)))

        @nodes.attr("cx", (d) => d.x)
              .attr("cy", (d) => d.y)
              .classed("fixed", (d) -> d.fixed.x or d.fixed.y)
              .classed("immovable", (d) -> d.immovable is true)
              .classed("selected", (d) => @selectedNodes.indexOf(d)+1)
              .transition()
                .duration(80)
                .ease("elastic")
                    .attr("r", (d) => @nodeSize/@drawscale * if (@selectedNodes.indexOf(d)+1 and not (d.immovable and @easel.currentTool.dontSelectImmovable)) then 2 else 1)

        @fixed.attr("d", (d) =>
            isc = @nodeSize*3.1/9/@drawscale
            """M #{-5*isc+d.x},#{-3*isc+d.y}
               l #{5*isc},#{8.6*isc}
               l #{5*isc},#{-8.6*isc} Z""")
             .classed("selected", (d) => @selectedNodes.indexOf(d)+1 and @easel.currentTool.dontSelectImmovable)

        @forces.attr("x2", (d) => d.x).attr("x1", (d) => d.x - d.force.x/4)
               .attr("y2", (d) => d.y).attr("y1", (d) => d.y - d.force.y/4)
               .attr("stroke-width", (d) => if not d.fixed.y and dist(f for d, f of d.force) > 0
                                               8/@drawscale*@showforce
                                            else 0)

        @grads.attr("x1", (d) => d.x).attr("x2", (d) => d.x + 1000/@drawscale*d.grad.x*w)
              .attr("y1", (d) => d.y).attr("y2", (d) => d.y + 1000/@drawscale*d.grad.y*w)
              .attr("stroke-width", (d) =>
                    if d.immovable is true
                        0
                    else if 50/@drawscale*dist(l for d, l of d.grad)*w > 0.125
                        10/@drawscale*(window.tool.showgrad and (@selectedNodes.indexOf(d) >= 0))
                    else
                        0)

    quickDraw: ->
        @structure.solve()
        @structure.solvegrad(@selectedNodes)
        @resize()
        w = @structure.nodeList.length/@structure.lp.obj

        @dragline.attr("stroke-width", 10/@drawscale)
                 .attr("stroke-dasharray", 10/@drawscale+","+10/@drawscale)

        @links.attr("x1", (d) => d.source.x).attr("x2", (d) => d.target.x)
              .attr("y1", (d) => d.source.y).attr("y2", (d) => d.target.y)

        @selectablelinks.attr("x1", (d) => d.source.x).attr("x2", (d) => d.target.x)
                        .attr("y1", (d) => d.source.y).attr("y2", (d) => d.target.y)

        @nodes.attr("cx", (d) => d.x).attr("cy", (d) => d.y)

        @forces.attr("x2", (d) => d.x).attr("x1", (d) => d.x - d.force.x/4)
               .attr("y2", (d) => d.y).attr("y1", (d) => d.y - d.force.y/4)

        @grads.attr("x1", (d) => d.x).attr("x2", (d) => d.x + 1000/@drawscale*d.grad.x*w)
              .attr("y1", (d) => d.y).attr("y2", (d) => d.y + 1000/@drawscale*d.grad.y*w)

    resize: ->
        w = @structure.nodeList.length/@structure.lp.obj
        @fea() if window.tool.autocolor

        @links.attr("stroke-width",  (d) => if d.size > 1e-3 then  sqrt(d.size/10) else 1)
              .classed("selected", (d) => @selectedLinks.indexOf(d)+1)

        @selectablelinks.attr("stroke-width",  (d) => max(2, 0.75 + sqrt(d.size/10)))
              .classed("selected", (d) => @selectedLinks.indexOf(d)+1)

        @nodes.classed("selected", (d) => @selectedNodes.indexOf(d)+1)
            .attr("r", (d) => @nodeSize/@drawscale * if (@selectedNodes.indexOf(d)+1 and not (d.immovable and @easel.currentTool.dontSelectImmovable)) then 2 else 1)

        @fixed.attr("d", (d) =>
            isc = @nodeSize*3.1/9/@drawscale
            """M #{-5*isc+d.x},#{-3*isc+d.y}
               l #{5*isc},#{8.6*isc}
               l #{5*isc},#{-8.6*isc} Z""")
              .classed("selected", (d) =>
                  @selectedNodes.indexOf(d)+1 and @easel.currentTool.dontSelectImmovable)

        @forces.attr("stroke-width", (d) => if not d.fixed.y and dist(f for d, f of d.force) > 0
                                               8/@drawscale*@showforce
                                            else 0)

        @grads.attr("stroke-width", (d) =>
                        if d.immovable is true
                            0
                        else if d.grad.x is 1000000000
                            0
                        else if 50/@drawscale*dist(l for dim, l of d.grad)*w > 0.125
                            10/@drawscale*(window.tool.showgrad and (@selectedNodes.indexOf(d) >= 0))
                        else
                            0)
    animateSelection: ->
        @structure.solvegrad(@selectedNodes)
        w = @structure.nodeList.length/@structure.lp.obj

        @fixed.classed("selected", (d) => @selectedNodes.indexOf(d)+1 and @easel.currentTool.dontSelectImmovable)

        @selectablelinks.attr("stroke-width",  (d) => max(2, 0.75 + sqrt(d.size/10)))
              .classed("selected", (d) => @selectedLinks.indexOf(d)+1)

        @nodes.classed("selected", (d) => @selectedNodes.indexOf(d)+1)
            .transition()
              .duration(80)
                  .attr("r", (d) => @nodeSize/@drawscale * if (@selectedNodes.indexOf(d)+1 and not (d.immovable and @easel.currentTool.dontSelectImmovable)) then 2 else 1)

        @grads.attr("x1", (d) => d.x)
              .attr("y1", (d) => d.y)
              .attr("x2", (d) => d.x)
              .attr("y2", (d) => d.y)
              .attr("stroke-width", 0)
              .transition()
                .duration(80)
                    .attr("x2", (d) => d.x + 1000/@drawscale*d.grad.x*w)
                    .attr("y2", (d) => d.y + 1000/@drawscale*d.grad.y*w)
                    .attr("stroke-width", (d) =>
                                if d.immovable is true
                                    0
                                else if d.grad.x is 1000000000
                                    0
                                else if 50/@drawscale*dist(l for dim, l of d.grad)*w > 0.125
                                    10/@drawscale*(window.tool.showgrad and (@selectedNodes.indexOf(d) >= 0))
                                else
                                    0)

window.tacit.Sketch = Sketch

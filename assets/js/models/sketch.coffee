abs = (n) -> Math.abs(n)
min = (n...) -> Math.min(n...)
max = (n...) -> Math.max(n...)
pow = (n, p) -> Math.pow(n, p)
sqr = (n) -> Math.pow(n, 2)
sqrt = (n) -> Math.sqrt(n)
sum = (o) -> if o.length then o.reduce((a,b) -> a+b) else ""
dist = (a, b) -> sqrt(sum(sqr(ai - (if b then b[i] else 0)) for ai, i in a))
print = (o) -> console.log(o)

window.tacit ?= {}

class Sketch
    constructor: (@pad, htmlLoc="body", structure, @height, @width) ->
        @showgrad = false
        @showforce = true
        @showzero = true

        htmlObj = d3.select(htmlLoc)

        if structure? then @structure = structure
        else @structure = new tacit.Structure

        @svg = htmlObj
                 .append("svg:svg")
                    .attr("width", @width)
                    .attr("height", @height)
                    .attr("pointer-events", "all")

        @scale = 1
        @translate = [0, 0]
        @nodeSize = 9
        easel = @pad.easel

        zoomer = d3.behavior.zoom().on("zoom", => @rescale() if easel.allowPan())
        mousedn = => @blank.call(d3.behavior.zoom().on("zoom"), => @rescale() if easel.allowPan())

        @selectedNodes = @selectedLinks = []
        @blank = @svg.append("svg:g")
                     .attr("transform", "translate(0,#{height}) scale(1,-1)")
                     .append("svg:g")
                        .call(zoomer)
                        .on("dblclick.zoom", null)
                        .append("svg:g")
                            .on("mousedown", mousedn)

        @rect = @blank.append("svg:rect")
                        .attr("x", -@width/2)
                        .attr("y", -@height/2)
                        .attr("width", @width)
                        .attr("height", @height)
                        .attr("fill", "transparent")
                        .on("mousedown", (d) ->
                            easel.mouseDown(easel, "background", d3.mouse(this), d))
                        .on("mousemove", (d) ->
                            easel.mouseMove(easel, "background", d3.mouse(this), d))
                        .on("mouseup", (d) ->
                            easel.mouseUp(easel, "background", d3.mouse(this), d))

        if not window.keysCaptured
            d3.select(window).on("keydown", ->
                                 easel.keyDown(easel, "window", d3.event.keyCode))
            window.keysCaptured = true

        # init nodes,  links, and the line displayed when dragging new nodes
        @nodes = @blank.selectAll(".node")
        @links = @blank.selectAll(".link")
        @forces = @blank.selectAll(".force")
        @grads = @blank.selectAll(".grad")
        @dragline = @blank.append("line")
                          .attr("class", "dragline")
                          .attr("x1", 0).attr("x2", 0)
                          .attr("y1", 0).attr("y2", 0)

        # set inital window
        if structure?
            [mins, maxs, means] = [{}, {}, {}]
            for d in ["x", "y", "z"]
                list = (n[d] for n in structure.nodeList)
                mins[d] = min(list...)
                maxs[d] = max(list...)
            scale = 0.75*min(@width/(maxs.x-mins.x), @height/(maxs.y-mins.y))
            translate = [scale*(mins.x-maxs.x)/2 + @width/2
                         scale*(mins.y-maxs.y)/2 + @height/2]
            zoomer.scale(scale)
            zoomer.translate(translate)
            @rescale(translate, scale, draw=false)

    rescale: (translate, scale, draw=true) ->
        translate ?= d3.event.translate
        scale ?= d3.event.scale
        translate = [translate[0]/scale, translate[1]/scale]

        [mins, maxs, means] = [{}, {}, {}]
        for d in ["x", "y", "z"]
            list = (n[d] for n in @structure.nodeList)
            mins[d] = min(list...)
            maxs[d] = max(list...)

        translatet = []
        translatet[0] = max(mins.x*scale - @translate[0], translate[0])
        translatet[1] = max(mins.y*scale - @translate[0], translate[1])
        print [translate[0], translatet[0]]

        @rect.attr("x", -translate[0])
             .attr("y", -translate[1])
             .attr("width", @width/scale)
             .attr("height", @height/scale)

        @scale = scale
        @translate = translate
        @blank.attr("transform", "scale(#{scale}) translate(#{translate})")
        if draw then @resize()

    updateDrawing: ->
        easel = @pad.easel

        @links = @links.data(@structure.beamList)
        @links.enter().insert("line", ".node")
              .attr("class", "link")
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
            .attr("class", "node")
            .attr("r", @nodeSize/@scale/2)
            .on("mousedown", (d) ->
                easel.mouseDown(easel, "node", d3.mouse(this), d))
            .on("mousemove", (d) ->
                easel.mouseMove(easel, "node", d3.mouse(this), d))
            .on("mouseup", (d) ->
                easel.mouseUp(easel, "node", d3.mouse(this), d))
          .transition()
            .duration(750)
            .ease("elastic")
            .attr("r", @nodeSize/@scale)
        @nodes.exit().transition()
            .attr("r", 0)
          .remove()

        @slowDraw()

    slowDraw: ->
        @structure.solve()
        w = @structure.nodeList.length/@structure.lp.obj

        @dragline.attr("stroke-width", 10/@scale)
                 .attr("stroke-dasharray", 10/@scale+","+10/@scale)

        @links.attr("x1", (d) => d.source.x).attr("x2", (d) => d.target.x)
              .attr("y1", (d) => d.source.y).attr("y2", (d) => d.target.y)
              .attr("stroke-dasharray", (d) => if d.F then null else 10/@scale+","+10/@scale)
              .classed("compression", (d) => d.f < 0)
              .classed("tension", (d) => d.f > 0)
              .classed("selected", (d) => @selectedLinks.indexOf(d)+1)
              .transition()
                .duration(750)
                .ease("elastic")
                    .attr("stroke-width",  (d) => 0.35*sqrt(d.F) or 5/@scale*@showzero)

        @nodes.attr("cx", (d) => d.x)
              .attr("cy", (d) => d.y)
              .classed("selected", (d) => @selectedNodes.indexOf(d)+1)
              .transition()
                .duration(750)
                .ease("elastic")
                    .attr("r", (d) => @nodeSize/@scale * if @selectedNodes.indexOf(d)+1 then 1.5 else 1)

        @forces.attr("x1", (d) => d.x).attr("x2", (d) => d.x + d.force.x/6)
               .attr("y1", (d) => d.y).attr("y2", (d) => d.y + d.force.y/6)
               .attr("stroke-width", (d) => if not d.fixed.y and dist(f for d, f of d.force) > 0
                                               8/@scale*@showforce
                                            else 0)

        @grads.attr("x1", (d) => d.x).attr("x2", (d) => d.x - 50/@scale*d.grad.x*w)
              .attr("y1", (d) => d.y).attr("y2", (d) => d.y - 50/@scale*d.grad.y*w)
              .attr("stroke-width", (d) =>
                    if 50/@scale*dist(l for d, l of d.grad)*w > 0.05
                        10/@scale*@showgrad
                    else
                        0)

        @onChange() if @onChange?

    quickDraw: ->
        @structure.solve()
        @resize()

        w = @structure.nodeList.length/@structure.lp.obj

        @dragline.attr("stroke-width", 10/@scale)
                 .attr("stroke-dasharray", 10/@scale+","+10/@scale)

        @links.attr("x1", (d) => d.source.x).attr("x2", (d) => d.target.x)
              .attr("y1", (d) => d.source.y).attr("y2", (d) => d.target.y)
              .classed("compression", (d) => d.f < 0)
              .classed("tension", (d) => d.f > 0)

        @nodes.attr("cx", (d) => d.x).attr("cy", (d) => d.y)

        @forces.attr("x1", (d) => d.x).attr("x2", (d) => d.x + d.force.x/6)
               .attr("y1", (d) => d.y).attr("y2", (d) => d.y + d.force.y/6)

        @grads.attr("x1", (d) => d.x)
              .attr("x2", (d) => d.x - 50/@scale*d.grad.x*w)
              .attr("y1", (d) => d.y)
              .attr("y2", (d) => d.y - 50/@scale*d.grad.y*w)

        @onChange() if @onChange?

    resize: ->
        w = @structure.nodeList.length/@structure.lp.obj

        @links.attr("stroke-dasharray", (d) => if d.F then null else 10/@scale+","+10/@scale)
              .attr("stroke-width",  (d) => 0.35*sqrt(d.F) or 5/@scale*@showzero)
              .classed("selected", (d) => @selectedLinks.indexOf(d)+1)

        @nodes.attr("r", (d) => @nodeSize/@scale * if @selectedNodes.indexOf(d)+1 then 1.5 else 1)
              .classed("selected", (d) => @selectedNodes.indexOf(d)+1)

        @forces.attr("stroke-width", (d) => if not d.fixed.y and dist(f for d, f of d.force) > 0
                                               8/@scale*@showforce
                                            else 0)

        @grads.attr("stroke-width", (d) =>
                    if 50/@scale*dist(l for d, l of d.grad)*w > 0.05
                        10/@scale*@showgrad
                    else
                        0)

window.tacit.Sketch = Sketch

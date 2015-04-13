abs = (n) -> Math.abs(n)
min = (n...) -> Math.min(n...)
max = (n...) -> Math.max(n...)
pow = (n, p) -> Math.pow(n, p)
sqr = (n) -> Math.pow(n, 2)
sqrt = (n) -> Math.sqrt(n)
sum = (o) -> if o.length then o.reduce((a,b) -> a+b) else ""
dist = (a, b) -> sqrt(sum(sqr(ai - (if b then b[i] else 0)) for ai, i in a))
print = (o) -> console.log(o)

@showgrad = {checked: false}
@showforce = {checked: true}
@showzero = {checked: true}
@move = {checked: false}

@tacit ?= {}

class Sketch
    constructor: (@pad, htmlLoc="body", structure, height, width) ->
        htmlObj = d3.select(htmlLoc)

        if structure? then @structure = structure
        else @structure = new tacit.Structure

        @svg = htmlObj
                 .append("svg:svg")
                    .attr("width", width)
                    .attr("height", height)
                    .attr("pointer-events", "all")

        @scale = 1
#        zoomer = d3.behavior.zoom().on("zoom", => @rescale())
#        mousedn = => @blank.call(d3.behavior.zoom().on("zoom"), => @rescale())

        @selected_node = @selected_link = null
        @blank = @svg.append("svg:g")
                     .attr("transform", "translate(0,#{height}) scale(1,-1)")
                     .append("svg:g")
                #        .call(zoomer)
                #        .on("dblclick.zoom", null)
                #        .append("svg:g")
                #            .on("mousedown", mousedn)

        tool = @pad.easel
        @blank.append("svg:rect")
                 .attr("x", -width/2)
                 .attr("y", -height/2)
                 .attr("width", width)
                 .attr("height", height)
                 .attr("fill", "transparent")
                 .on("mousedown", (d) ->
                     easel.currentTool.mouseDown(easel, "background", d3.mouse(this), d)
                     return false)
                 .on("mousemove", (d) ->
                     easel.currentTool.mouseMove(easel, "background", d3.mouse(this), d)
                     return false)
                 .on("mouseup", (d) ->
                     easel.currentTool.mouseUp(easel, "background", d3.mouse(this), d)
                     return false)

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
                means[d] = sum(list)/structure.nodeList.length
            @scale = 0.5*min(width/(maxs.x-mins.x), height/(maxs.y-mins.y))
            translate = [@scale*means.x, height/2 - @scale*means.y]
            #zoomer.scale(@scale)
            #zoomer.translate(translate)
            @rescale(translate, @scale, draw=false)

    rescale: (translate, scale, draw=true) ->
        translate ?= d3.event.translate
        scale ?= d3.event.scale
        @scale = scale
        @blank.attr("transform", "translate(#{translate}) scale(#{scale})")
        if draw then @resize()

    redraw: ->
      tool = @pad.easel
      @links = @links.data(@structure.beamList)
      @links.enter().insert("line", ".node")
            .attr("class", "link")
            .on("mousedown", (d) ->
                easel.currentTool.mouseDown(easel, "beam", d3.mouse(this), d)
                return false)
            .on("mousemove", (d) ->
                easel.currentTool.mouseMove(easel, "beam", d3.mouse(this), d)
                return false)
            .on("mouseup", (d) ->
                easel.currentTool.mouseUp(easel, "beam", d3.mouse(this), d)
                return false)
      @links.exit().transition()
          .attr("r", 0)
        .remove()
      @links.classed("selected", (d) => d is @selected_link)

      @forces = @forces.data(@structure.nodeList)
      @forces.enter().insert("line")
          .attr("class", "force")
          .attr("stroke-width", 0)
          .attr("marker-end", "url(#brtriangle)")
      @forces.exit().remove()

      @grads = @grads.data(@structure.nodeList)
      @grads.enter().insert("line")
          .attr("class","grad")
          .attr("stroke-width", 0)
          .attr("marker-end", "url(#ptriangle)")
      @grads.exit().remove()

      @nodes = @nodes.data(@structure.nodeList)
      @nodes.enter().insert("circle")
          .attr("class", "node")
          .attr("r", 5/@scale)
          .on("mousedown", (d) ->
              easel.currentTool.mouseDown(easel, "node", d3.mouse(this), d)
              return false)
          .on("mousemove", (d) ->
              easel.currentTool.mouseMove(easel, "node", d3.mouse(this), d)
              return false)
          .on("mouseup", (d) ->
              easel.currentTool.mouseUp(easel, "node", d3.mouse(this), d)
              return false)
        .transition()
          .duration(750)
          .ease("elastic")
          .attr("r", 9/@scale)
      @nodes.exit().transition()
          .attr("r", 0)
        .remove()
      @nodes.classed("node_selected", (d) => d is @selected_node)

      @reposition_transition()

    reposition_transition: ->
        @structure.solve()
        w = @structure.nodeList.length/@structure.lp.obj

        @dragline.attr("stroke-width", 10/@scale)
                 .attr("stroke-dasharray", 10/@scale+","+10/@scale)

        @links.attr("x1", (d) => d.source.x).attr("x2", (d) => d.target.x)
              .attr("y1", (d) => d.source.y).attr("y2", (d) => d.target.y)
              .attr("stroke-dasharray", (d) => if d.F then null else 10/@scale+","+10/@scale)
              .classed("compression", (d) => d.f < 0)
              .classed("tension", (d) => d.f > 0)
              .transition()
                .duration(750)
                .ease("elastic")
                    .attr("stroke-width",  (d) => 0.035*d.F or 5/@scale*showzero.checked)

        @nodes.attr("cx", (d) => d.x)
              .attr("cy", (d) => d.y)
              .transition()
                .duration(750)
                .ease("elastic")
                    .attr("r", (d) => 18/@scale * if d is @selected_node then 2 else 1)

        @forces.attr("x1", (d) => d.x).attr("x2", (d) => d.x + d.force.x/4)
               .attr("y1", (d) => d.y).attr("y2", (d) => d.y + d.force.y/4)
               .attr("stroke-width", (d) => if dist(f for d, f of d.force) > 0
                                               10/@scale*showforce.checked
                                            else 0)

        @grads.attr("x1", (d) => d.x).attr("x2", (d) => d.x - 50/@scale*d.grad.x*w)
              .attr("y1", (d) => d.y).attr("y2", (d) => d.y - 50/@scale*d.grad.y*w)
              .attr("stroke-width", (d) => if 50/@scale*dist(l for d, l of d.grad)*w > 0.05
                                              10/@scale*showgrad.checked
                                           else 0)

    reposition: ->
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

        @forces.attr("x1", (d) => d.x).attr("x2", (d) => d.x + d.force.x/4)
               .attr("y1", (d) => d.y).attr("y2", (d) => d.y + d.force.y/4)

        @grads.attr("x1", (d) => d.x)
              .attr("x2", (d) => d.x - 50/@scale*d.grad.x*w)
              .attr("y1", (d) => d.y)
              .attr("y2", (d) => d.y - 50/@scale*d.grad.y*w)

    resize: ->
        w = @structure.nodeList.length/@structure.lp.obj

        @links.attr("stroke-dasharray", (d) => if d.F then null else 10/@scale+","+10/@scale)
              .attr("stroke-width",  (d) => 0.035*d.F or 5/@scale*showzero.checked)

        @nodes.attr("r", (d) => 18/@scale * if d is @selected_node then 2 else 1)

        @forces.attr("stroke-width", (d) => if dist(f for d, f of d.force) > 0
                                               10/@scale*showforce.checked
                                            else 0)

        @grads.attr("stroke-width", (d) => if 50/@scale*dist(l for d, l of d.grad)*w > 0.05
                                              10/@scale*showgrad.checked
                                           else 0)

@tacit.Sketch = Sketch

abs = (n) -> Math.abs(n)
pow = (n, p) -> Math.pow(n, p)
sqr = (n) -> Math.pow(n, 2)
sqrt = (n) -> Math.sqrt(n)
sum = (o) -> if o.length then o.reduce((a,b) -> a+b) else ""
dist = (a, b) -> sqrt(sum(sqr(ai-(if b then b[i] else 0)) for ai, i in a))
print = (o) -> console.log(o)
isempty = (o) -> Object.keys(o).length is 0

window.tacit ?= {}

gen_classes = (nodeLookup, nodeIDLookup, nodeList, beamList, nodes, beams) ->
    class Node
        constructor: (pos) ->
            # initialize attributes
            @id = nodes++
            [@x, @y, @z] = [pos.x, pos.y, if pos.z? then pos.z else 0]
            @force = {x: 0, y: 0, z: 0}
            @grad = {x: 0, y: 0, z: 0}
            @fixed = {x: false, y: false, z: not pos.z?}
            @sourced = []
            @targeted = []
            # add the node to lookups and the list
            nodeLookup[@z] ?= {}
            nodeLookup[@z][@y] ?= {}
            if nodeLookup[@z][@y][@x]?
                throw "a node is already there, aborting."
            else
                nodeLookup[@z][@y][@x] = @id
            nodeIDLookup[@id] = this
            nodeList.push(this)
        moveto: (pos) ->
            delta = {}
            (if pos[d]? then delta[d] = pos[d] - this[d]) for d in "xyz"
            @move(delta)
        move: (delta) ->
            # cleanup nodeLookup
            delete nodeLookup[@z][@y][@x]
            if isempty nodeLookup[@z][@y] then delete nodeLookup[@z][@y]
            if isempty nodeLookup[@z] then delete nodeLookup[@z]
            # apply changes
            (if delta[d]? then this[d] += delta[d]) for d in "xyz"
            beam.update() for beam in @sourced.concat(@targeted)
            # reenter into nodeLookup
            nodeLookup[@z] ?= {}
            nodeLookup[@z][@y] ?= {}
            nodeLookup[@z][@y][@x] = @id
        constraints: ->
            constraints = {}
            # generate a linear constraint for each non-fixed dimension
            for d, fix of @fixed
                constraints[d] =
                    A: (b.l[d]/b.L for b in @sourced).concat(
                       -b.l[d]/b.L for b in @targeted)
                    i: (b.id for b in @sourced).concat(b.id for b in @targeted)
                    b: -@force[d]
            return constraints
        delete: ->
            beam.delete() for beam in @sourced.concat(@targeted)
            pos = nodeList.indexOf(this)
            if pos + 1
                nodeList.splice(pos, 1)
                delete nodeIDLookup[@id]
                delete nodeLookup[@z][@y][@x]
                delete nodeLookup[@z][@y] if isempty nodeLookup[@z][@y]
                delete nodeLookup[@z] if isempty nodeLookup[@z]
                delete this


    getNodeIDX = (pt) ->
        try
            if not pt.x? then pt
            else
                lookedup = nodeLookup[if pt.z? then pt.z else 0][pt.y][pt.x]
                if lookedup isnt undefined then return lookedup
                else throw "node doesn't exist yet"
        catch error
            (new Node(pt)).id

    class Beam
        constructor: (pts...) ->
            [@source, @target] = (nodeIDLookup[getNodeIDX(pt)] for pt in pts)
            # determine physical characteristics
            [@f, @F] = [0, 0]
            @l = {}
            @update()
            @grad = {x: 0, y: 0, z: 0}
            # add to start and end nodes, and the list
            @id = beams++
            @source.sourced.push(this)
            @target.targeted.push(this)
            beamList.push(this)
        update: ->
            @l[d] = @target[d] - @source[d] for d in "xyz"
            @L = dist(l for d, l of @l)
        delete: ->
            for list in [@source.sourced, @target.targeted, beamList]
                pos = list.indexOf(this)
                if pos + 1 then list.splice(pos, 1)
            delete this


    class LPresult
        constructor: (@lp) ->
            @obj = glp_get_obj_val(@lp)
            @obj = 1e6 if not @obj
            for i in [1..glp_get_num_cols(lp)]
                [name, prim] = [glp_get_col_name(lp, i), glp_get_col_prim(lp, i)]
                this[name] = prim
                if name[0] is "q"
                    [id, dim] = [name[1..-2], name[-1..]]
                    nodeIDLookup[id].force[dim] = prim
            for i in [1..glp_get_num_rows(lp)]
                [name, dual] = [glp_get_row_name(lp, i), glp_get_row_dual(lp, i)]
                this[name] = dual if name[0..2] isnt "abs"

    strsign = (n) -> if n > 0 then "+" else "-"

    LPstring = ->
        reactionforces = []
        lp  =   "Minimize
               \n  obj:" + sum(" + #{beam.L} F#{beam.id}" for beam in beamList)
        lp += "\n
               \nSubject To"
        for node in nodeList
            for dim, c of node.constraints()
                con = ""
                con += " #{strsign(a)} #{abs(a)} f#{c.i[j]}
                                " for a, j in c.A when a isnt 0
                if con
                    if not node.fixed[dim]
                        lp += "\n  n#{node.id}#{dim}:#{con} = #{c.b}"
                    else
                        lp += "\n  n#{node.id}#{dim}:#{con} - q#{node.id}#{dim} = 0"
                        reactionforces.push("q#{node.id}#{dim}")
        lp += "\n  absf#{b.id}p: + f#{b.id} - F#{b.id} <= 0
               \n  absf#{b.id}n: - f#{b.id} - F#{b.id} <= 0" for b in beamList
        lp += "\n
               \nBounds"
        lp += "\n  f#{beam.id} free
               \n  F#{beam.id} >= 0" for beam in beamList
        lp += "\n  #{q} free" for q in reactionforces
        lp += "\n
               \nEnd\n"
        lp = lp.replace(new RegExp("               ", "g"),"")
        return lp

    solveLP = ->
        lp = glp_create_prob()
        glp_read_lp_from_string(lp, null, LPstring())
        glp_scale_prob(lp, GLP_SF_AUTO)
        smcp = new SMCP({presolve: GLP_ON})
        glp_simplex(lp, smcp)
        return new LPresult(lp)

    return [Node, Beam, solveLP]


class Structure
    # TODO: import / export list of coordinates etc. + list of connections
    constructor: (tacfile) ->
        if tacfile? then @import(tacfile)
        [@nodeLookup, @nodeIDLookup] = [{}, {}]
        [@nodeList, @beamList] = [[], []]
        [@nodes, @beams] = [0, 0]
        [@Node, @Beam, @solveLP] = gen_classes(@nodeLookup, @nodeIDLookup,
                                               @nodeList,   @beamList,
                                               @nodes,      @beams)
    solve: ->
        try
            @lp = @solveLP()
            for beam in @beamList
                beam.f = @lp["f#{beam.id}"]
                beam.F = abs(beam.f)
            for node in @nodeList
                node.lambda = {}
                for dim in "xyz"
                    lambda = @lp["n#{node.id}#{dim}"]
                    node.lambda[dim] = lambda
                    if lambda
                        #print node.sourced
                        #as = sum((b.F/b.f)*b.l[dim]/sqr(b.L) for b in node.sourced)
                        #as = 0
                        #bs = sum(b.f/b.L*(1-2*sqr(b.l[dim]/b.L)) for b in node.sourced)
                        #grad = bs/((1/lambda) - as)
                        grad = 0.5*sum(1/((b.f/b.F) * b.l[dim]/sqr(b.L)) for b in node.sourced)
                        # print ["n#{node.id}#{dim}", lambda, "grad", grad, "obj", @lp.obj]
                        node.grad[dim] = if isNaN(grad) then 0 else grad
        catch error







print "Testing tacit.Structure..."
approx = (a,b) -> 1e-10 >= abs(a-b)/(abs(a)+abs(b))
s = new Structure
[nodeList, nodeLookup, beamList] = [s.nodeList, s.nodeLookup, s.beamList]
[Node, Beam, solveLP] = [s.Node, s.Beam, s.solveLP]
## TEST 1 # access a 2D node via nodeList and nodeLookup
n = new Node({x:0, y:0})
n.fixed.x = true
print "Failed Test 1" if nodeList[nodeLookup[0][0][0]].fixed.x isnt true
## TEST 2 # make sure fixed constraints are null
 # deprecated now that we use those constraints to determine reaction forces
 # print "Failed Test 2" if n.constraints().x or n.constraints().z
## TEST 3 # connect two nodes with a beam
n.fixed.x = false # unfix the node at 0,0
b = new Beam({x: 0, y: 0}, {x: 1, y: 1})
print "Failed Test 3.0" if beamList[0] isnt b
print "Failed Test 3.1" if b.source.id isnt 0 or b.target.id isnt 1
print "Failed Test 3.2" if nodeList[0].sourced[0].id isnt 0
print "Failed Test 3.3" if nodeList[1].targeted[0].id isnt 0
## TEST 4 # test constraint generation
new Beam({x: 1, y: 1}, {x: 2, y: 0})
rt2 = sqrt(2)
print "Failed Test 4.0" if nodeList[1].constraints().x.i[0] isnt 1
print "Failed Test 4.1" if nodeList[1].constraints().x.i[1] isnt 0
print "Failed Test 4.2" if not approx(nodeList[1].constraints().x.A[0], rt2/2)
print "Failed Test 4.3" if not approx(nodeList[1].constraints().x.A[1], -rt2/2)
print "Failed Test 4.4" if not approx(nodeList[1].constraints().y.A[0], -rt2/2)
print "Failed Test 4.5" if not approx(nodeList[1].constraints().y.A[1], -rt2/2)
## TEST 5 # test LP solution
nodeList[i].fixed[dim] = true for i in [0,2] for dim in ["x", "y"]
nodeList[1].force.y = -1
lp = solveLP()
print "Failed Test 5.0" if not approx(lp.obj, 2)
print "Failed Test 5.1" if not approx(lp.f0, -rt2/2)
print "Failed Test 5.2" if not approx(lp.f0, lp.f1)
## TEST 6 # test 3D structures, independent problems, and moving nodes
s2 = new Structure
new s2.Beam({x: 0, y: 0, z: 0}, {x: 1, y: 0})
new s2.Beam({x: 0, y: 0, z: 0}, {x: -1, y: 0})
new s2.Beam({x: 0, y: 0, z: 0}, {x: 0, y: 1})
new s2.Beam({x: 0, y: 0, z: 0}, {x: 0, y: -1})
s2.nodeList[i].fixed[dim] = true for i in [1..4] for dim in ["x", "y"]
s2.nodeList[0].force = {x: 1, y: 1, z: 1}
s2.nodeList[0].move({z: 1})
print "Failed Test 6" if not approx(s2.solveLP().obj, 4)
## TEST 7 # test deleting nodes
## TEST 8 # test 2D gradient descent
## TEST 9 # test 3D gradient descent
print "                       ...testing complete."

window.tacit.Structure = Structure

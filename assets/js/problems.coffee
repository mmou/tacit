gd = 1.65

window.sign = ->
    structure = new tacit.Structure
    new structure.Node({x:20, y:gd})
    new structure.Node({x:60, y:gd})
    new structure.Beam({x:47, y:72}, {x:47, y:97})
    structure.nodeList[i].fixed.y = true for i in [0,1]
    structure.nodeList[i].fixed.x = true for i in [0,1]
    structure.nodeList[2].force.x = 50
    structure.nodeList[3].force.x = 50
    node.immovable = true for node in structure.nodeList
    window.problem_description =
        title: "sign"
        text: """
        <p> You will be designing support for a road sign able to withstand gale force winds.

        <img src="assets/resources/introimages/sign_intro_2.jpg" />

        <p> We have formulated this as a simplified structural problem in two dimensions: you will develop a structure to anchors a horizontally loaded beam between two fixed supports.

        <img src="assets/resources/introimages/sign.png" />

        <p> The goal of this problem is to reduce the cost of your viable solutions, as determined by the mass of steel used in all the beams of your design. If your design reaches the cost threshold you will receive an extra $10 in compensation and if your design is the best design made with this software tool you will receive an additional $65 in compensation.
        """

    window.genhelper = ->
        window.helper = window.easel.pad.sketch.background.append("g").attr("id", "helper").attr("transform", "scale(-0.12, 0.12) rotate(180) translate(140, -925)").attr("opacity", 0.3)

        window.helper.append("path").attr("d", "m 274.15625,202.90625 -0.5,50 101.25,1 c 30.04341,0.30037 57.89842,2.00396 80.15625,11.8125 21.89707,9.64957 40.16888,28.52914 47.375,50 7.2457,21.5888 4.22896,47.75249 -7.0625,69.21875 -11.52006,21.90084 -31.45657,40.70126 -54.71875,56.1875 -23.45556,15.61501 -50.62461,28.58361 -78.28125,44.28125 -27.76834,15.76105 -55.67472,34.47165 -79,59.8125 -23.43869,25.46405 -40.63393,56.41134 -49.6875,89.90625 -9.05529,33.50127 -9.39222,66.7839 -9.15625,97.78125 l 0.5,65.15625 50,-0.375 -0.5,-65.1875 c -0.22961,-30.16255 0.50244,-58.80218 7.40625,-84.34375 6.90553,-25.54793 20.23628,-49.55738 38.21875,-69.09375 18.09588,-19.65957 41.48367,-35.75789 66.90625,-50.1875 25.53428,-14.49302 53.82517,-27.84673 81.28125,-46.125 27.64952,-18.407 54.32845,-42.30217 71.28125,-74.53125 17.1814,-32.66366 22.43353,-72.01193 10.21875,-108.40625 -12.25436,-36.51226 -40.55387,-64.82932 -74.625,-79.84375 -33.71039,-14.85544 -68.69727,-15.75141 -99.8125,-16.0625 l -101.25,-1 z")

        window.helper.append("path").attr("d", "M 250.6446,866.99644 186.66003,758.22268 312.96581,757.2612 250.6446,866.99644 z")

    window.project.name = "sign"

    goalweights = {optimal: 360, auto: 400, manual: 450}
    $("#goalweight").text("$"+goalweights[window.tool.name])

    return structure


window.bridge = ->
    hg = 50

    structure = new tacit.Structure

    new structure.Node({x:0, y:gd})
    new structure.Node({x:100, y:gd})
    structure.nodeList[i].fixed.y = true for i in [0,1]
    structure.nodeList[i].fixed.x = true for i in [0,1]
    new structure.Beam({x:0, y:gd}, {x:33, y:gd})
    new structure.Beam({x:33, y:gd}, {x:66, y:gd})
    new structure.Beam({x:66, y:gd}, {x:100, y:gd})
    # new structure.Beam({x:2, y:gd}, {x:200, y:gd})
    structure.nodeList[2].force.y = -160
    structure.nodeList[3].force.y = -160
    node.immovable = true for node in structure.nodeList
    window.problem_description =
        title: "bridge",
        text: """
        <p> You will be designing a bridge to span a deep river and support the passage of cars along its roadbed.

        <img src="assets/resources/introimages/bridge_intro_2.jpg" />

        <p> We have formulated this as a simplified structural problem in two dimensions: you will develop a structure to span the two fixed supports and support two loads in the center.

        <img src="assets/resources/introimages/bridge.png" />

        <p> The goal of this problem is to reduce the cost of your viable solutions, as determined by the mass of steel used in all the beams of your design. If your design reaches the cost threshold you will receive an extra $10 in compensation, and if your design is the best design made with this software tool you will receive an additional $65 in compensation.
        """

    window.project.name = "bridge"
    goalweights = {optimal: 375, auto: 425, manual: 475}
    $("#goalweight").text("$"+goalweights[window.tool.name])
    window.scalemult = 0.3

    return structure

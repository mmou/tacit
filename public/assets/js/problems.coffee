gd = 1.65

window.tutorialstruct = ->
    gd = 1.65
    structure = new tacit.Structure
    new structure.Node({x:20, y:gd})
    new structure.Node({x:60, y:gd})
    new structure.Beam({x:20, y:60}, {x:60, y:60})
    structure.nodeList[i].fixed.y = true for i in [0,1]
    structure.nodeList[i].fixed.x = true for i in [0,1]
    structure.nodeList[i].force.x = 40 for i in [2,3]
    structure.nodeList[i].force.y = -10 for i in [2,3]
    beam.immovable = true for beam in structure.beamList
    node.immovable = true for node in structure.nodeList
    window.problem_description =
        title: "tutorial"
        text: "#{if location.hash.length > 3 then "Let's build a quick scaffold! Follow the tutorial on the right side of the page." else "We're going to complete a shortened version of the scaffold exercise with a  new tool. Follow the tutorial on the right side of the page."}"
    window.tutorial = true
    window.genhelper = ->
        window.helper = project.easel.pad.sketch.background.append("g").attr("id", "helper").attr("transform", "scale(-0.12, 0.135) rotate(180) translate(-20, -750)").attr("opacity", 0.3)

        window.helper.append("path").attr("d", "M 339.96875 335.625 C 339.96875 335.625 339.96886 335.99228 339.96875 336 L 339.625 336 C 339.625 336 339.69057 340.99297 339.78125 346.125 C 339.39293 368.15254 338.21494 427.71107 335.6875 492.15625 C 334.52282 521.8533 329.84792 558.21994 322.34375 591.375 C 314.83958 624.53006 304.07312 654.68548 292.875 670.84375 C 281.93959 686.62293 270.52732 690.85598 261.3125 692.1875 C 259.96867 692.38168 258.69632 692.49305 257.5 692.5625 L 257 676.90625 L 212.25 704.6875 L 258.65625 729.53125 L 258.25 717 C 260.34829 716.91718 262.53242 716.76697 264.8125 716.4375 C 279.51514 714.31299 298.42617 705.8868 313.03125 684.8125 C 327.86103 663.41394 338.38021 631.55169 346.25 596.78125 C 348.39207 587.31711 350.29122 577.65692 351.96875 567.96875 C 353.68003 578.11339 355.6426 588.2578 357.84375 598.1875 C 365.70594 633.65494 376.14989 666.16943 391.0625 687.6875 C 405.75198 708.88359 425.1124 716.70674 440 717.96875 L 439.5625 731.71875 L 488.96875 705.25 L 441.34375 675.6875 L 440.78125 693.4375 C 432.00427 692.4549 421.56483 688.6788 411.21875 673.75 C 400.10346 657.71124 389.26177 626.76163 381.75 592.875 C 374.23823 558.98837 369.57122 521.86077 368.40625 492.15625 C 365.87881 427.71108 364.70082 368.15255 364.3125 346.125 C 364.40376 340.96283 364.46875 335.96875 364.46875 335.96875 L 364.125 335.96875 C 364.1249 335.96226 364.125 335.625 364.125 335.625 L 352.5625 335.8125 L 339.96875 335.625 z ")
    return structure

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
    beam.immovable = true for beam in structure.beamList
    window.problem_description =
        title: "road sign"
        text: """
        <p> You will be designing support for a road sign able to withstand strong winds.

        <img src="assets/resources/introimages/sign_nathan.jpg" width="100%" />

        <p> We have formulated this as a simplified structural problem in two dimensions: you will develop a structure to anchor a horizontally loaded beam between two fixed supports.

        <img src="assets/resources/introimages/sign.png" />

        <p> The goal of this problem is to reduce the cost of your viable solutions, as determined by the mass of steel used in all the beams of your design. If your design reaches the cost threshold you will receive an extra $5 in compensation and if your design is the best design made with this software tool you will receive an additional $55 in compensation.
        """

    window.genhelper = ->
        window.helper = project.easel.pad.sketch.background.append("g").attr("id", "helper").attr("transform", "scale(-0.12, 0.12) rotate(180) translate(140, -925)").attr("opacity", 0.3)

        window.helper.append("path").attr("d", "m 274.15625,202.90625 -0.5,50 101.25,1 c 30.04341,0.30037 57.89842,2.00396 80.15625,11.8125 21.89707,9.64957 40.16888,28.52914 47.375,50 7.2457,21.5888 4.22896,47.75249 -7.0625,69.21875 -11.52006,21.90084 -31.45657,40.70126 -54.71875,56.1875 -23.45556,15.61501 -50.62461,28.58361 -78.28125,44.28125 -27.76834,15.76105 -55.67472,34.47165 -79,59.8125 -23.43869,25.46405 -40.63393,56.41134 -49.6875,89.90625 -9.05529,33.50127 -9.39222,66.7839 -9.15625,97.78125 l 0.5,65.15625 50,-0.375 -0.5,-65.1875 c -0.22961,-30.16255 0.50244,-58.80218 7.40625,-84.34375 6.90553,-25.54793 20.23628,-49.55738 38.21875,-69.09375 18.09588,-19.65957 41.48367,-35.75789 66.90625,-50.1875 25.53428,-14.49302 53.82517,-27.84673 81.28125,-46.125 27.64952,-18.407 54.32845,-42.30217 71.28125,-74.53125 17.1814,-32.66366 22.43353,-72.01193 10.21875,-108.40625 -12.25436,-36.51226 -40.55387,-64.82932 -74.625,-79.84375 -33.71039,-14.85544 -68.69727,-15.75141 -99.8125,-16.0625 l -101.25,-1 z")

        window.helper.append("path").attr("d", "M 250.6446,866.99644 186.66003,758.22268 312.96581,757.2612 250.6446,866.99644 z")

    window.project.name = "sign"

    goalweights = {optimal: 360, auto: 400, manual: 450}
    $("#goalweight").text("$"+goalweights[window.tool.name])
    $("#bestweight").text("$"+goalweights[window.tool.name])

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
    beam.immovable = true for beam in structure.beamList
    window.problem_description =
        title: "bridge",
        text: """
        <p> You will be designing a bridge to span a deep river and support the passage of cars along its roadbed.

        <img src="assets/resources/introimages/bridge_nathan.jpg" width="100%" />

        <p> We have formulated this as a simplified structural problem in two dimensions: you will develop a structure to span the two fixed supports and support two loads in the center.

        <img src="assets/resources/introimages/bridge.png" />

        <p> The goal of this problem is to reduce the cost of your viable solutions, as determined by the mass of steel used in all the beams of your design. If your design reaches the cost threshold you will receive an extra $5 in compensation, and if your design is the best design made with this software tool you will receive an additional $55 in compensation.
        """

    window.project.name = "bridge"
    goalweights = {optimal: 375, auto: 425, manual: 475}
    $("#goalweight").text("$"+goalweights[window.tool.name])
    $("#bestweight").text("$"+goalweights[window.tool.name])
    window.scalemult = 0.45

    window.genhelper = ->
        window.helper = project.easel.pad.sketch.background.append("g").attr("id", "helper").attr("transform", "scale(-0.28, 0.28) rotate(180) translate(-30, -375)").attr("opacity", 0.3)

        window.helper.append("path").attr("d", "M 308 316.71875 C 303.70367 316.81645 299.34884 317.40161 295.0625 318.65625 C 286.40327 321.19089 278.23639 326.51156 273.21875 334.71875 C 269.45578 340.87372 267.84138 348.14105 268.625 355.3125 L 282.25 353.84375 C 281.80454 349.76704 282.79837 345.40514 284.9375 341.90625 C 287.81 337.2078 293.07939 333.55847 298.9375 331.84375 C 304.88216 330.1037 311.61804 330.10234 318.34375 331.25 C 327.25834 332.77118 335.94726 336.15928 344 340.8125 C 345.21813 341.51639 346.40752 342.27165 347.59375 343.03125 L 341.71875 350.75 L 352.78125 352.15625 L 361.34375 353.21875 L 372.40625 354.625 L 368.09375 344.34375 L 364.75 336.40625 L 360.40625 326.125 L 355.90625 332.0625 C 354.2558 330.98276 352.58613 329.92627 350.875 328.9375 C 341.62398 323.59186 331.41059 319.55919 320.625 317.71875 C 316.53238 317.02039 312.29633 316.62109 308 316.71875 z M 104.375 317.0625 C 101.20298 317.15888 98.077891 317.51138 95.03125 318.03125 C 84.325832 319.85801 74.213494 323.88161 65.03125 329.1875 C 63.336699 330.16668 61.671944 331.21145 60.03125 332.28125 L 55.5625 326.375 L 51.25 336.59375 L 47.9375 344.46875 L 43.625 354.6875 L 54.625 353.28125 L 63.125 352.21875 L 74.09375 350.84375 L 68.25 343.15625 C 69.429378 342.40069 70.631472 341.66926 71.84375 340.96875 C 79.836628 336.35012 88.464196 332.97861 97.3125 331.46875 C 103.98821 330.32962 110.66203 330.33538 116.5625 332.0625 C 122.37705 333.76447 127.6176 337.36772 130.46875 342.03125 C 132.59197 345.50414 133.56715 349.8286 133.125 353.875 L 146.65625 355.375 C 147.43404 348.25686 145.82875 341.04671 142.09375 334.9375 C 137.1134 326.79133 129.00112 321.48454 120.40625 318.96875 C 116.15177 317.72343 111.82689 317.15943 107.5625 317.0625 C 106.4964 317.03827 105.43234 317.03037 104.375 317.0625 z")

    return structure


window.bridge2 = ->
    hg = 50

    structure = new tacit.Structure

    new structure.Node({x:0, y:gd})
    new structure.Node({x:100, y:gd})
    structure.nodeList[i].fixed.y = true for i in [0,1]
    structure.nodeList[i].fixed.x = true for i in [0,1]
    new structure.Beam({x:0, y:gd}, {x:33, y:5})
    new structure.Beam({x:33, y:5}, {x:66, y:5})
    new structure.Beam({x:66, y:5}, {x:100, y:gd})
    # new structure.Beam({x:2, y:gd}, {x:200, y:gd})
    structure.nodeList[2].force.y = -160
    structure.nodeList[3].force.y = -160
    node.immovable = true for node in structure.nodeList
    beam.immovable = true for beam in structure.beamList
    window.problem_description =
        title: "bridge",
        text: """
        <p> You will be designing a bridge to span a deep river and support the passage of cars along its roadbed.

        <img src="assets/resources/introimages/bridge_nathan.jpg" width="100%" />

        <p> We have formulated this as a simplified structural problem in two dimensions: you will develop a structure to span the two fixed supports and support two loads in the center.

        <img src="assets/resources/introimages/bridge.png" />

        <p> The goal of this problem is to reduce the cost of your viable solutions, as determined by the mass of steel used in all the beams of your design. If your design reaches the cost threshold you will receive an extra $5 in compensation, and if your design is the best design made with this software tool you will receive an additional $55 in compensation.
        """

    window.project.name = "bridge"
    goalweights = {optimal: 375, auto: 425, manual: 475}
    $("#goalweight").text("$"+goalweights[window.tool.name])
    $("#bestweight").text("$"+goalweights[window.tool.name])
    window.scalemult = 0.45

    window.genhelper = ->
        window.helper = project.easel.pad.sketch.background.append("g").attr("id", "helper").attr("transform", "scale(-0.28, 0.28) rotate(180) translate(-30, -383)").attr("opacity", 0.3)

        window.helper.append("path").attr("d", "M 308 316.71875 C 303.70367 316.81645 299.34884 317.40161 295.0625 318.65625 C 286.40327 321.19089 278.23639 326.51156 273.21875 334.71875 C 269.45578 340.87372 267.84138 348.14105 268.625 355.3125 L 282.25 353.84375 C 281.80454 349.76704 282.79837 345.40514 284.9375 341.90625 C 287.81 337.2078 293.07939 333.55847 298.9375 331.84375 C 304.88216 330.1037 311.61804 330.10234 318.34375 331.25 C 327.25834 332.77118 335.94726 336.15928 344 340.8125 C 345.21813 341.51639 346.40752 342.27165 347.59375 343.03125 L 341.71875 350.75 L 352.78125 352.15625 L 361.34375 353.21875 L 372.40625 354.625 L 368.09375 344.34375 L 364.75 336.40625 L 360.40625 326.125 L 355.90625 332.0625 C 354.2558 330.98276 352.58613 329.92627 350.875 328.9375 C 341.62398 323.59186 331.41059 319.55919 320.625 317.71875 C 316.53238 317.02039 312.29633 316.62109 308 316.71875 z M 104.375 317.0625 C 101.20298 317.15888 98.077891 317.51138 95.03125 318.03125 C 84.325832 319.85801 74.213494 323.88161 65.03125 329.1875 C 63.336699 330.16668 61.671944 331.21145 60.03125 332.28125 L 55.5625 326.375 L 51.25 336.59375 L 47.9375 344.46875 L 43.625 354.6875 L 54.625 353.28125 L 63.125 352.21875 L 74.09375 350.84375 L 68.25 343.15625 C 69.429378 342.40069 70.631472 341.66926 71.84375 340.96875 C 79.836628 336.35012 88.464196 332.97861 97.3125 331.46875 C 103.98821 330.32962 110.66203 330.33538 116.5625 332.0625 C 122.37705 333.76447 127.6176 337.36772 130.46875 342.03125 C 132.59197 345.50414 133.56715 349.8286 133.125 353.875 L 146.65625 355.375 C 147.43404 348.25686 145.82875 341.04671 142.09375 334.9375 C 137.1134 326.79133 129.00112 321.48454 120.40625 318.96875 C 116.15177 317.72343 111.82689 317.15943 107.5625 317.0625 C 106.4964 317.03827 105.43234 317.03037 104.375 317.0625 z")

    return structure

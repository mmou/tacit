$(document).ready(function() {

	// initialize easel and stuff
	window.easel = new tacit.Easel(null, "#ToolbarView", "#PadView", 450, 900);
	window.sketch = easel.pad.sketch;
	s = sketch.structure;
	console.log(s);

	sketch.updateDrawing();

	setTimeout(function() {
	    s.nodeList[0].move({ y: -200 });
	    sketch.slowDraw();
	  }, 800);

  	setTimeout(function() {
      s.nodeList[0].move({ y: 200 });
  	    return sketch.slowDraw();
  	  }, 1500);


	// this code won't work now, but once easel/pad
	// have been initialized, we should make "draw" the initial tool

	$('.active').removeClass("active")
	$("#draw-btn").addClass("active")
	easel.currentTool = tacit.tools.draw

	// Create tutorial button

	$(document).click(function(evt){
		if($(evt.target).is("#tutorial-btn") && $("#instructions").length == 0){
			//Add div containing temporary tutorials
			$("#Tutorial").append(
				"<div id='instructions'>" +
					"<p> <span style='color:#ff4444'>Red lines</span> indicate a beam which is being pushed in at each end (compression). </p>" +
					"<p> <span style='color:#00c7ff'>Blue lines</span> indicate a beam being pulled at each end (in tension). </p>" +
					"<p> The circles represent pinned or welded joints; beams can rotate around these joints, so a certain number of beams are needed to make a structure stable. </p>" +
					"<p> Unstable structures have only unused beams (dotted brown), while stable structures also have beams colored by their use. </p>" +
				"</div>"
				);
		} else {
			$("#instructions").remove();
			$("#tutorial-btn").removeClass("active");
			//How do I get it to look unclicked?
			evt.stopImmediatePropagation();

		}
	});



})

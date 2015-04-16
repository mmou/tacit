$(document).ready(function() {

	// initialize easel and stuff
	easel = new tacit.Easel(null, "#ToolbarView", "#PadView", 450, 900);
	sketch = easel.pad.sketch;
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

	window.project = {"easel": easel};

	suggestions = new tacit.Suggestions(project, "#SuggestionsView")

})

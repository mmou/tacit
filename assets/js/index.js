$(document).ready(function() {

	// initialize easel and stuff
	var height = parseInt($(window).height()*0.9);
	var width = parseInt($(window).width()*0.7);
	var easelHeight = (height < 450 || height > 1000) ? 450 : height;
	var easelWidth =  (width < 1000 || width > 1500 ) ? 1000 : width;	
	easel = new tacit.Easel(null, "#ToolbarView", "#PadView", easelHeight, easelWidth);
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

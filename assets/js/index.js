$(document).ready(function() {

	// initialize easel and stuff
	var height = parseInt($(window).height()*0.7);
	var width = parseInt($(window).width()*0.7);
	var easelHeight = (height < 450 || height > 1000) ? 450 : height;
	var easelWidth =  (width < 1000 || width > 1500 ) ? 640 : width;
	window.project = {"name":"my_chair"};
	easel = new tacit.Easel(window.project, "#ToolbarView", "#PadView", easelHeight, easelWidth);
	window.project.easel = easel;
	window.project.actionQueue = [];
	sketch = easel.pad.sketch;
	s = sketch.structure;
	console.log(s);

	sketch.updateDrawing();

  	// activate tooltips
	$('[data-toggle="tooltip"]').tooltip()

  	// make draw the default active tool
	$('.active').removeClass("active")
	$("#draw-btn").addClass("active")
	easel.currentTool = tacit.tools.draw


	$("#PadView svg").css({'cursor': 'url(assets/resources/cursor-images/pencil.png) 0 16, auto'})

/*	$(document).click(function(evt){
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
*/

	$("#PadView").on('mouseover', function() {
	console.log("on Pad");
		if (easel.currentTool.name == "select"){
			$("#PadView svg").css({'cursor': 'default'})
		} else if (easel.currentTool.name == "move"){
			$("#PadView svg").css({'cursor': 'pointer'})
		} else if (easel.currentTool.name == "draw"){
			$("#PadView svg").css({'cursor': 'url(assets/resources/cursor-images/pencil.png) 0 16, auto'})
		} else if (easel.currentTool.name == "erase") {
			$("#PadView svg").css({'cursor': 'url(assets/resources/cursor-images/eraser.png) 6 16, auto'})
		} else if (easel.currentTool.name == "measure") {
			$("#PadView svg").css({'cursor': 'url(assets/resources/cursor-images/ruler.png) 6 20, auto'})
		} else if (easel.currentTool.name == "load") {
			$("#PadView svg").css({'cursor': 'default'})
		} else {
				console.log("no tool selected");

	}
});

	var gridBox = $('input[name=grid]');
	gridBox.click(function(){
		if(gridBox.is(":checked")){
			sketch.rect.attr("fill", "url(#grid)");
		} else {
			sketch.rect.attr("fill", "transparent");

		}
	});

	var baseLineBox = $('input[name=baseLine]');
	baseLineBox.click(function(){
		if(baseLineBox.is(":checked")){
			sketch.baseLine.attr("stroke", "black");
		} else {
			sketch.baseLine.attr("stroke", "transparent");

		}
	});


	// update project name on input change
	$("#ProjectName").on("input", function(e){
		window.project.name = $("#ProjectName").val();
	})

	// unfocus the name input on enter
	$("#ProjectName").keypress(function (e) {
  		if (e.which == 13) {
   			$("#ProjectName").trigger('blur');
    		return false;
  		}
	});

	$("#save-btn").attr("disabled", true)
	$("#undo-btn").attr("disabled", true)
	$("#redo-btn").attr("disabled", true)

	$("#export-btn").click(function() {easel.export()})	

	suggestions = new tacit.Suggestions(window.project, "#SuggestionsView");
	versions = new tacit.Versions(window.project, "#HistorySketchesView");
	undoredo = new tacit.UndoRedo(window.project)

})

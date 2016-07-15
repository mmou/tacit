$(document).ready(function() {

$('#ToolbarView').on('click', '.toolbar-btn', function(e) {
	// make tool current tool
	if (project.easel.currentTool === tacit.tools.draw) {
		project.easel.currentTool.stopDrawing(project.easel)
	}
	var toolName = e.target.id || e.target.parentElement.id;
	if (toolName === "select-btn") {
		project.easel.currentTool = tacit.tools.select
		$("#PadView svg").css({'cursor': 'default'})
	} else if (toolName === "move-btn") {
		project.easel.currentTool = tacit.tools.move
		$("#PadView svg").css({'cursor': 'pointer'})
	} else if (toolName === "draw-btn") {
		if (window.tutorial_state === 5)
            window.advance_tutorial();
		project.easel.currentTool = tacit.tools.draw
		$("#PadView svg").css({'cursor': 'url(assets/resources/cursor-images/pencil.png) 0 16, auto'})

	} else if (toolName === "erase-btn") {
		project.easel.currentTool = tacit.tools.erase
		$("#PadView svg").css({'cursor': 'url(assets/resources/cursor-images/eraser.png) 6 16, auto'})

	} else if (toolName === "thicken-btn") {
		project.easel.currentTool = tacit.tools.thicken
		$("#PadView svg").css({'cursor': 'url(assets/resources/cursor-images/ruler.png) 6 20, auto'})


	} else if (toolName === "load-btn") {
		if (window.tutorial_state === 3)
            window.advance_tutorial();
		project.easel.currentTool = tacit.tools.load
		$("#PadView svg").css({'cursor': 'default'})
		//$("#PadView svg").css({'cursor': 'url(assets/resources/cursor-images/weight.png) 10 10, auto'})

	} else {
		//Currently an issue with not pressing on image itself
		console.log("invalid tool")
	}

	$('.active').removeClass("active")
	$("#"+toolName).addClass("active")
})
})

$(document).ready(function() {

$('#ToolbarView').on('click', '.toolbar-btn', function(e) {
	// make tool current tool
	var tool = $(e.target).parent()
	var toolName = tool.prop('id')
	if (toolName === "select-btn") {
		easel.currentTool = tacit.tools.select
		$("#PadView").css({'cursor': 'default'})
	} else if (toolName === "move-btn") {
		easel.currentTool = tacit.tools.move
		$("#PadView").css({'cursor': 'pointer'})
	} else if (toolName === "draw-btn") {
		easel.currentTool = tacit.tools.draw
		$("#PadView").css({'cursor': 'url(assets/resources/cursor-images/pencil.png) 0 17, auto'})

	} else if (toolName === "erase-btn") {
		easel.currentTool = tacit.tools.erase
		$("#PadView").css({'cursor': 'url(assets/resources/cursor-images/eraser.png) 0 18, auto'})

	} else if (toolName === "measure-btn") {
		easel.currentTool = tacit.tools.measure
		$("#PadView").css({'cursor': 'url(assets/resources/cursor-images/ruler.png) 0 20, auto'})


	} else if (toolName === "test-btn") {
		easel.currentTool = tacit.tools.test
		$("#PadView").css({'cursor': 'url(assets/resources/cursor-images/weight.png) 10 10, auto'})

	} else {
		//Currently an issue with not pressing on image itself
		console.log("invalid tool")
	}

	$('.active').removeClass("active")
	$("#"+toolName).addClass("active")

	/* 
	
	todo: css+js to make custom cursor images. 
	it'll be like the moving checkers thing.

	*/
})
})
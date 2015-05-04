$(document).ready(function() {

$('#ToolbarView').on('click', '.toolbar-btn', function(e) {
	// make tool current tool
	var toolName = e.target.id || e.target.parentElement.id;
	if (toolName === "select-btn") {
		easel.currentTool = tacit.tools.select
		$("#PadView svg").css({'cursor': 'default'})
	} else if (toolName === "move-btn") {
		easel.currentTool = tacit.tools.move
		$("#PadView svg").css({'cursor': 'pointer'})
	} else if (toolName === "draw-btn") {
		easel.currentTool = tacit.tools.draw
		$("#PadView svg").css({'cursor': 'url(assets/resources/cursor-images/pencil.png) 0 16, auto'})

	} else if (toolName === "erase-btn") {
		easel.currentTool = tacit.tools.erase
		$("#PadView svg").css({'cursor': 'url(assets/resources/cursor-images/eraser.png) 6 16, auto'})

	} else if (toolName === "measure-btn") {
		easel.currentTool = tacit.tools.measure
		$("#PadView svg").css({'cursor': 'url(assets/resources/cursor-images/ruler.png) 6 20, auto'})


	} else if (toolName === "test-btn") {
		easel.currentTool = tacit.tools.load
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

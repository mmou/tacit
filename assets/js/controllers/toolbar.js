$(document).ready(function() {

$('#ToolbarView').on('click', '.toolbar-btn', function(e) {
	// make tool current tool
	var tool = $(e.target).parent()
	var toolName = tool.prop('id')
	if (toolName === "select-btn") {
		easel.currentTool = tacit.tools.select
	} else if (toolName === "draw-btn") {
		easel.currentTool = tacit.tools.draw
	} else if (toolName === "erase-btn") {
		easel.currentTool = tacit.tools.erase
/*	} else if (toolName === "measure-btn") {
		easel.currentTool = tacit.tools.measure
*/	} else if (toolName === "test-btn") {
		easel.currentTool = tacit.tools.test
	} else {
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
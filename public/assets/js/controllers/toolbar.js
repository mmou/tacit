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
		console.log("switched to move button");
		window.log += "# switched to move tool at "+new Date().toLocaleString()+" \n"
	        window.db.ref('events/').push().set({
	          type: "move",
		  timestamp: new Date().toLocaleString(),
	        });
		project.easel.currentTool = tacit.tools.move
		$("#PadView svg").css({'cursor': 'pointer'})
	} else if (toolName === "draw-btn") {
		console.log("switched to draw button");
		window.log += "# switched to draw tool at "+new Date().toLocaleString()+" \n"
	        window.db.ref('events/').push().set({
	          type: "draw",
		  timestamp: new Date().toLocaleString(),
	        });
		if (window.tutorial_state === 5)
            window.advance_tutorial();
		project.easel.currentTool = tacit.tools.draw
		$("#PadView svg").css({'cursor': 'url(assets/resources/cursor-images/pencil.png) 0 16, auto'})

	} else if (toolName === "erase-btn") {
		window.log += "# switched to erase tool at "+new Date().toLocaleString()+" \n"
	        window.db.ref('events/').push().set({
	          type: "erase",
		  timestamp: new Date().toLocaleString(),
	        });
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

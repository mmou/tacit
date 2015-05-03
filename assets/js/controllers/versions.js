$(document).ready(function() {

	$("#save-btn").click(function() {
		versions.save()
	})

	$("#undo-btn").click(function() {
		undoredo.undo()
	})

	$("#redo-btn").click(function() {
		undoredo.redo()
	})

	$("#PadView").on("mouseup", function() {
		var tool = project.easel.currentTool;
		if (tool && 
			tool.name === "draw" || 
			tool.name === "erase" || 
			tool.name === "move") {
			undoredo.log()
		}

	})


})

$(document).ready(function() {

	var updateUndoBtn = function() {
		var disable = (undoredo.pointer-1 < 0)
		$("#undo-btn").attr("disabled", disable)
	}

	var updateRedoBtn = function() {
		var disable = (undoredo.pointer+1 >= project.actionQueue.length)
		$("#redo-btn").attr("disabled", disable)
	}

	var updateSaveBtn = function() {
		var disable = (project.actionQueue.length <= 1)
		$("#save-btn").attr("disabled", disable)
	}

	var updateAllBtns = function() {
		updateUndoBtn();
		updateRedoBtn();
		updateSaveBtn();
	}

	$("#save-btn").click(function() {
		if (window.tutorial_state === 1)
			window.advance_tutorial()
		versions.save()
		updateAllBtns();
		var hsv = $("#HistorySketchesView");
		var hsvpos = hsv.scrollLeft();
		farRightScroll = 60*hsv.children().length - hsv.width()
		if (farRightScroll === 60+hsvpos) { // was at far edge
			hsv.scrollLeft(farRightScroll);
		}
	})

	$("#undo-btn").click(function() {
		undoredo.undo();
		updateAllBtns();
	})

	$("#redo-btn").click(function() {
		undoredo.redo()
		updateAllBtns();
	})

	$("#PadView").on("mouseup", function() {
		$("#ProjectName").trigger('blur');
		$(".notyet").removeClass("notyet")
		if (window.tutorial_state === 0)
			window.advance_tutorial()
		var tool = project.easel.currentTool;
		if (tool &&
			tool.name === "draw" ||
			tool.name === "erase" ||
			tool.name === "move") {
			undoredo.log()
			updateAllBtns();
		}
	})

	$("#SuggestionsView").on("mouseup", function() {
		updateAllBtns();
	})

})

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
		if (farRightScroll > hsvpos) { // was at far edge
			hsv.scrollLeft(farRightScroll);
		}
		var ph = $("#PreviewHistory");
		var phpos = ph.scrollLeft();
		farRightScroll = 60*ph.children().length - ph.width()
		if (farRightScroll > phpos) { // was at far edge
			ph.scrollLeft(farRightScroll);
		}
	})

	$("#undo-btn").click(function() {
		undoredo.undo();
		updateAllBtns();
	})

	$("#redo-btn").click(function() {
		undoredo.redo();
		updateAllBtns();
	})

	$("#PadView").on("mouseup", function() {
		$("#ProjectName").trigger('blur');
		$(".notyet").removeClass("notyet")
		updateAllBtns();
		if (window.tutorial_state === 0)
			window.advance_tutorial()
	})

	$("#SuggestionsView").on("mouseup", function() {
		updateAllBtns();
	})

})

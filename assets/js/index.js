function initialize(structure) {
	window.tutorial_state = -1
	finalsurvey = "http://mit.co1.qualtrics.com/SE/?SID=SV_5ngp53FTyAwm46x"
	intermediatesurveys = {
						 "ab": "http://mit.co1.qualtrics.com/SE/?SID=SV_5ngp53FTyAwm46x",
	                     "mb": "http://mit.co1.qualtrics.com/SE/?SID=SV_5ngp53FTyAwm46x",
	                     "ob": "http://mit.co1.qualtrics.com/SE/?SID=SV_5ngp53FTyAwm46x",
	                     "as": "http://mit.co1.qualtrics.com/SE/?SID=SV_5ngp53FTyAwm46x",
	                     "ms": "http://mit.co1.qualtrics.com/SE/?SID=SV_5ngp53FTyAwm46x",
	                     "os": "http://mit.co1.qualtrics.com/SE/?SID=SV_5ngp53FTyAwm46x",
	                       }

	// initialize easel and stuff
	var height = parseInt($(window).height() - 110);
	$("#HistoryView").css("max-width", 60*Math.floor(($(window).width()-660)/60))
	var offset = window.tutorial ? 510 : 200;
	if (window.feapad)
		var width = parseInt($(window).width() - offset);
	else
		var width = parseInt($(window).width()/2 - offset/2);
	window.project = {"name": "untitled", "onChange": function(){}};
	global_weight = document.getElementById("designweight")
	easel = new tacit.Easel(window.project, "#PadView",
						    height, width, structure, global_weight);
	window.project.easel = easel;
	window.project.actionQueue = [];
	sketch = easel.pad.sketch;
	s = sketch.structure;
	sketch.updateDrawing();

  	// activate tooltips
	$('[data-toggle="tooltip"]').tooltip()

  	// make draw the default active tool
	$('.active').removeClass("active")
	$("#move-btn").addClass("active")
	easel.currentTool = tacit.tools.move


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
		} else if (easel.currentTool.name == "thicken"){
				$("#PadView svg").css({'cursor': 'default'})
		} else {
				console.log("no tool selected");

	}
});

	var gridBox = $('input[name=grid]');
	gridBox.click(function(){
		if(gridBox.is(":checked")){
			easel.pad.sketch.rect.attr("fill", "url(#grid)");
        } else {
          easel.pad.sketch.rect.attr("fill", "transparent");

        }
      });

      var baseLineBox = $('input[name=baseLine]');
      baseLineBox.click(function(){
        if(baseLineBox.is(":checked")){
          easel.pad.sketch.baseLine.attr("stroke", "#3d3130");
        } else {
          easel.pad.sketch.baseLine.attr("stroke", "transparent");

        }
      });

	// update project name on input change
	$("#ProjectName").on("input", function(e){
		e.stopPropagation();
	    var text = $('<span style="display: none;">')
	        .html($(this).val().replace(/ /g, "&nbsp;"))
	        .appendTo(this.parentNode);
	    var w = Math.min(400, 12 + text.innerWidth());
	    text.remove();
		$("#ProjectName").width(w);
		$("#HistoryView").css("max-width", 60*Math.floor(($(window).width()-570-w)/60))
		window.project.name = $("#ProjectName").val();
		document.title = $("#ProjectName").val() + " | tacit.blue";
	})

	// unfocus the name input on enter
	$("#ProjectName").keypress(function (e) {
  		if (e.which == 13) {
   			$("#ProjectName").trigger('blur');
    		return false;
  		}
	});
	$("#export-btn").click(function() {
		if (window.tutorial)
			return nextTutorialStep();
		if (location.hash[1] === "t" ) {
			location.hash = location.hash.substr(2)
			console.log(location.hash)
			location.reload()
		} else if (location.hash.search("x") !== -1) {
			location.hash = location.hash.substr(3)
			console.log(location.hash)
			location.reload()
		} else {
			easel.saveLog()
			if (location.hash.length < 6)
	            location.href = finalsurvey
	        else
	            location.href = intermediatesurveys[location.hash.substr(4,2)]
		}
		})
	$("#zoom-btn").click(function() {
		if (window.triggers.zoom !== undefined)
            window.triggers.zoom()
		easel.pad.sketch.defaultZoom()})

	window.updateTool = function () {
		if (window.tool.autocolor) {
			$("#fea-btn").hide()
		} else {
			$("#fea-btn").show()
		}
		easel.pad.sketch.slowDraw()
	}

    updateTool()
	$("#fea-btn").click(function() {easel.pad.sketch.fea()})

	versions = new tacit.Versions(window.project, "#HistorySketchesView");
	undoredo = new tacit.UndoRedo(window.project)

	$(".notyet").removeClass("notyet")
}

window.initialize = initialize;

window.startClock = function () {
	function getTimeRemaining(endtime){
	  var t = Date.parse(endtime) - Date.parse(new Date());
	  var seconds = Math.floor( (t/1000) % 60 );
	  var minutes = Math.floor( (t/1000/60) % 60 );
	  return {
		'total': t,
		'minutes': minutes,
		'seconds': seconds
	  };
	}

	function initializeClock(id, endtime){
	  var clock = document.getElementById(id);
	  var timeinterval = setInterval(function(){
		var t = getTimeRemaining(endtime);
		var seconds = t.seconds;
		if (seconds >= 0) {
			if (seconds < 10)
				seconds = "0" + seconds
			if (t.minutes >= 1)
				clock.innerHTML =  ' | ' + t.minutes + ' minutes';
			else {
				clock.innerHTML = " | " + t.minutes + ':' + seconds;
				if (seconds < 1)
					$("#export-btn").click()
			}
			if(t.total<=0){
			  clearInterval(timeinterval);
			}
		}
	  }, 1000);
	}

	var mins = window.tutorial ? 15.99 : 12.99
	var d = new Date
	initializeClock("timer", new Date(d.getTime() + mins*60000));
}

// Generated by CoffeeScript 1.9.2
(function() {
  var Easel;

  if (window.tacit == null) {
    window.tacit = {};
  }

  
// from http://stackoverflow.com/questions/3665115/create-a-file-in-memory-for-user-to-download-not-through-server
function download(filename, text) {
  var pom = document.createElement('a');
  pom.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
  pom.setAttribute('download', filename);

  pom.style.display = 'none';
  document.body.appendChild(pom);

  pom.click();

  document.body.removeChild(pom);
}
;

  Easel = (function() {
    function Easel(project, toolbarLoc, padLoc, padHeight, padWidth, structure) {
      var padHtmlRect;
      this.project = project;
      padHtmlRect = d3.select(padLoc).node().getBoundingClientRect();
      if (padWidth == null) {
        padWidth = htmlRect.width;
      }
      if (padHeight == null) {
        padHeight = htmlRect.height;
      }
      this.pad = new tacit.Pad(this, padLoc, padHeight, padWidth, structure);
    }

    Easel.prototype.allowPan = function() {
      if (this.currentTool.allowPan != null) {
        return this.currentTool.allowPan;
      } else {
        return false;
      }
    };

    Easel.prototype["export"] = function() {
      var filename;
      filename = this.project.name != null ? this.project.name : "tacit";
      filename += ".svg";
      return download(filename, d3.select(easel.pad.htmlLoc).html());
    };

    Easel.prototype.mouseDown = function(easel, eventType, mouseLoc, object) {
      $("footer").height(32);
      if (this.currentTool != null) {
        if (this.currentTool.mouseDown != null) {
          this.currentTool.mouseDown(easel, eventType, mouseLoc, object);
        }
      }
      if (eventType === "node") {
        this.selection = object;
      }
      return false;
    };

    Easel.prototype.mouseUp = function(easel, eventType, mouseLoc, object) {
      if (this.currentTool != null) {
        if (this.currentTool.mouseUp != null) {
          this.currentTool.mouseUp(easel, eventType, mouseLoc, object);
        }
      }
      undoredo.log();
      this.selection = null;
      return false;
    };

    Easel.prototype.mouseMove = function(easel, eventType, mouseLoc, object) {
      var change;
      if (this.currentTool != null) {
        if (this.currentTool.mouseMove != null) {
          this.currentTool.mouseMove(easel, eventType, mouseLoc, object);
        }
      }
      if (!this.currentTool.dragging) {
        change = false;
        if (eventType === "node") {
          if (!1 + easel.pad.sketch.selectedNodes.indexOf(object)) {
            change = true;
            easel.pad.sketch.selectedNodes = [object];
          }
        } else if (easel.pad.sketch.selectedNodes.length > 0) {
          change = true;
          this.selection = null;
          easel.pad.sketch.selectedNodes = [];
        }
        if (change && object !== this.selection) {
          if (eventType === "node") {
            easel.project.onChange();
            this.selection = object;
          }
          easel.pad.sketch.animateSelection();
        }
      }
      return false;
    };

    Easel.prototype.keyDown = function(easel, eventType, keyCode) {
      var i, j, len, len1, link, node, ref, ref1;
      if (this.currentTool != null) {
        if (this.currentTool.keyDown != null) {
          if (this.currentTool.keyDown(easel, eventType, keyCode)) {
            return false;
          }
        }
      }
      switch (d3.event.keyCode) {
        case 8:
        case 46:
          ref = this.pad.sketch.selectedNodes;
          for (i = 0, len = ref.length; i < len; i++) {
            node = ref[i];
            node["delete"]();
          }
          ref1 = this.pad.sketch.selectedLinks;
          for (j = 0, len1 = ref1.length; j < len1; j++) {
            link = ref1[j];
            link["delete"]();
          }
          this.pad.sketch.selectedLinks = this.pad.sketch.selectedNodes = [];
          this.pad.sketch.updateDrawing();
          break;
        case 68:
          easel.currentTool = tacit.tools.draw;
          $('.active').removeClass("active");
            	 $("#draw-btn").addClass("active");
                 $("#PadView svg").css({'cursor': 'url(assets/resources/cursor-images/pencil.png) 0 16, auto'});;
          break;
        case 69:
          if (d3.event.metaKey || d3.event.ctrlKey) {
            $("#export-btn").click();
          } else {
            easel.currentTool = tacit.tools.erase;
            $('.active').removeClass("active");
                	 $("#erase-btn").addClass("active");
                     $("#PadView svg").css({'cursor': 'url(assets/resources/cursor-images/eraser.png) 6 16, auto'});;
          }
          break;
        case 76:
          easel.currentTool = tacit.tools.load;
          $('.active').removeClass("active");
            	 $("#load-btn").addClass("active");
                 $("#PadView svg").css({'cursor': 'default'});;
          break;
        case 77:
          easel.currentTool = tacit.tools.move;
          $('.active').removeClass("active");
            	 $("#move-btn").addClass("active");
                 $("#PadView svg").css({'cursor': 'pointer'});;
          break;
        case 83:
          if (d3.event.metaKey || d3.event.ctrlKey) {
            $("#save-btn").click();
            d3.event.preventDefault();
          }
          break;
        case 89:
          if (d3.event.metaKey || d3.event.ctrlKey) {
            $("#redo-btn").click();
          }
          break;
        case 90:
          if (d3.event.metaKey || d3.event.ctrlKey) {
            if (d3.event.shiftKey) {
              $("#redo-btn").click();
            } else {
              $("#undo-btn").click();
            }
          }
      }
      return false;
    };

    return Easel;

  })();

  window.tacit.Easel = Easel;

}).call(this);

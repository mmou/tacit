// Generated by CoffeeScript 1.9.2
(function() {
  var Suggestions, dummyEasel, r;

  if (window.tacit == null) {
    window.tacit = {};
  }

  r = function() {
    return 2 * Math.random() - 1;
  };

  dummyEasel = {
    mouseDown: function(easel, eventType, mouseLoc, object) {
      if (this.currentTool != null) {
        if (this.currentTool.mouseDown != null) {
          this.currentTool.mouseDown(easel, eventType, mouseLoc, object);
        }
      }
      return false;
    },
    mouseUp: function(easel, eventType, mouseLoc, object) {
      if (this.currentTool != null) {
        if (this.currentTool.mouseUp != null) {
          this.currentTool.mouseUp(easel, eventType, mouseLoc, object);
        }
      }
      return false;
    },
    mouseMove: function(easel, eventType, mouseLoc, object) {
      if (this.currentTool != null) {
        if (this.currentTool.mouseMove != null) {
          this.currentTool.mouseMove(easel, eventType, mouseLoc, object);
        }
      }
      return false;
    }
  };

  Suggestions = (function() {
    function Suggestions(project, htmlLoc) {
      var i, j, structure;
      this.project = project;
      this.htmlLoc = htmlLoc;
      this.project.easel.pad.sketch.onChange = (function(_this) {
        return function() {
          return _this.update(_this.project.easel.pad.sketch.structure);
        };
      })(this);
      structure = new tacit.Structure(this.project.easel.pad.sketch.structure);
      this.pads = [];
      for (i = j = 1; j <= 3; i = ++j) {
        this.pads.push(new tacit.Pad(dummyEasel, this.htmlLoc, 200, 200, structure));
      }
      this.update(structure);
    }

    Suggestions.prototype.mutate = function(structure) {
      var delta, dg, j, len, node, ref, results;
      ref = structure.nodeList;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        node = ref[j];
        dg = 200 * r() * structure.nodeList.length / structure.lp.obj;
        delta = {
          x: node.grad.x * dg * !node.fixed.x,
          y: node.grad.y * dg * !node.fixed.y,
          z: node.grad.z * dg * !node.fixed.z
        };
        results.push(node.move(delta));
      }
      return results;
    };

    Suggestions.prototype.update = function(structure) {
      var i, j, len, pad, ref, results;
      ref = this.pads;
      results = [];
      for (i = j = 0, len = ref.length; j < len; i = ++j) {
        pad = ref[i];
        structure = new tacit.Structure(structure);
        structure.solve();
        this.mutate(structure);
        pad.load(structure);
        pad.sketch.nodeSize = 0;
        pad.sketch.showforce = false;
        pad.sketch.updateDrawing();
        results.push(pad.sketch.svg.on("mousedown", (function(_this) {
          return function(d) {
            console.log(structure.lp.obj);
            _this.project.easel.pad.load(structure);
            _this.project.easel.pad.sketch.onChange = function() {
              return _this.update(_this.project.easel.pad.sketch.structure);
            };
            return _this.project.easel.pad.sketch.updateDrawing();
          };
        })(this)));
      }
      return results;
    };

    return Suggestions;

  })();

  window.tacit.Suggestions = Suggestions;

}).call(this);

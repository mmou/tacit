// Generated by CoffeeScript 1.4.0
(function() {
  var Versions, dummyEasel, _ref;

  if ((_ref = window.tacit) == null) {
    window.tacit = {};
  }

  dummyEasel = (function() {

    function dummyEasel(versions, i) {
      this.versions = versions;
      this.i = i;
      null;
    }

    dummyEasel.prototype.mouseDown = function(easel, eventType, mouseLoc, object) {
      var structure;
      if (window.triggers.load != null) {
        window.triggers.load();
      }
      structure = new tacit.Structure(this.versions.history[this.i].sketch.structure);
      this.versions.project.easel.pad.load(structure);
      this.versions.project.easel.pad.sketch.feapad = window.feapadpad;
      console.log(this.versions.project.easel.pad.sketch.feapad != null);
      this.versions.project.easel.pad.sketch.updateDrawing();
      this.versions.project.easel.pad.sketch.fea();
      this.versions.project.onChange();
      window.log += "\n# loaded structure\n" + structure.strucstr;
      return false;
    };

    dummyEasel.prototype.allowPan = function() {
      return false;
    };

    dummyEasel.prototype.mouseUp = function(easel, eventType, mouseLoc, object) {
      return false;
    };

    dummyEasel.prototype.mouseMove = function(easel, eventType, mouseLoc, object) {
      return false;
    };

    return dummyEasel;

  })();

  Versions = (function() {

    function Versions(project, htmlLoc) {
      this.project = project;
      this.htmlLoc = htmlLoc;
      this.history = [];
      this.newVersion();
    }

    Versions.prototype.newVersion = function() {
      var easel, genhelper, pad, saved, structure, versionObj;
      structure = new tacit.Structure(this.project.easel.pad.sketch.structure);
      this.project.easel.pad.sketch.fea();
      structure.solve();
      versionObj = d3.select(this.htmlLoc).append("div").attr("id", "ver" + this.history.length).classed("ver", true);
      easel = new dummyEasel(this, this.history.length);
      versionObj.append("div").attr("id", "versvg" + this.history.length).classed("versvg", true);
      easel.weightDisplay = versionObj.append("div").classed("verwd", true)[0][0];
      pad = new tacit.Pad(easel, "#versvg" + this.history.length, 50, 50, structure);
      pad.load(structure, genhelper = false);
      pad.sketch.nodeSize = 0;
      pad.sketch.showforce = false;
      pad.sketch.updateDrawing();
      this.history.push(pad);
      pad.sketch.fea();
      saved = Math.round(pad.sketch.structure.lp.obj / 100);
      if (saved <= $("#bestweight").text().substr(1)) {
        $("#bestweight").text("$" + saved);
        $("#bestcontainer").css("display", "");
        if (window.triggers.beat != null) {
          return window.triggers.beat();
        }
      }
    };

    Versions.prototype.save = function() {
      var currently_at, structure;
      if (window.triggers.save != null) {
        window.triggers.save();
      }
      if (this.project.actionQueue.length > 1) {
        this.newVersion();
      }
      currently_at = this.project.actionQueue[undoredo.pointer];
      structure = new tacit.Structure(currently_at);
      structure.solve();
      this.project.actionQueue = [structure];
      undoredo.pointer = 0;
      return window.log += "\n# saved";
    };

    return Versions;

  })();

  window.tacit.Versions = Versions;

}).call(this);

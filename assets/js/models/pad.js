// Generated by CoffeeScript 1.4.0
(function() {
  var Pad, _ref;

  if ((_ref = this.tacit) == null) {
    this.tacit = {};
  }

  Pad = (function() {

    function Pad(easel, htmlLoc, height, width, structure) {
      var dim, gd, i, _i, _j, _k, _l, _len, _len1, _len2, _len3, _ref1, _ref2, _ref3, _ref4;
      this.easel = easel;
      this.htmlLoc = htmlLoc;
      this.height = height;
      this.width = width;
      gd = 1.75;
      if (!(structure != null)) {
        structure = new tacit.Structure;
        new structure.Beam({
          x: 20,
          y: gd
        }, {
          x: 70,
          y: 30
        });
        new structure.Beam({
          x: 70,
          y: 30
        }, {
          x: 80,
          y: gd
        });
        new structure.Beam({
          x: 80,
          y: gd
        }, {
          x: 40,
          y: 30
        });
        new structure.Beam({
          x: 40,
          y: 30
        }, {
          x: 20,
          y: gd
        });
        new structure.Beam({
          x: 40,
          y: 30
        }, {
          x: 70,
          y: 30
        });
        new structure.Beam({
          x: 20,
          y: gd
        }, {
          x: 25,
          y: 40
        });
        new structure.Beam({
          x: 25,
          y: 40
        }, {
          x: 0,
          y: 90
        });
        new structure.Beam({
          x: 0,
          y: 90
        }, {
          x: 20,
          y: gd
        });
        new structure.Beam({
          x: 25,
          y: 40
        }, {
          x: 40,
          y: 30
        });
        _ref1 = [0, 2];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          i = _ref1[_i];
          structure.nodeList[i].fixed.y = true;
        }
        _ref2 = [0];
        for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
          i = _ref2[_j];
          structure.nodeList[i].fixed.x = true;
        }
        structure.nodeList[1].force.y = -75;
        structure.nodeList[3].force.y = -50;
        _ref3 = "xy";
        for (_k = 0, _len2 = _ref3.length; _k < _len2; _k++) {
          dim = _ref3[_k];
          structure.nodeList[4].force[dim] = -30;
        }
        _ref4 = "xy";
        for (_l = 0, _len3 = _ref4.length; _l < _len3; _l++) {
          dim = _ref4[_l];
          structure.nodeList[5].force[dim] = -15;
        }
      }
      this.sketch = new tacit.Sketch(this, this.htmlLoc, structure, this.height, this.width);
    }

    Pad.prototype.load = function(structure) {
      var scale, translate;
      this.sketch.svg.remove();
      translate = [this.sketch.translate[0] * this.sketch.scale, this.sketch.translate[1] * this.sketch.scale];
      scale = this.sketch.scale;
      return this.sketch = new tacit.Sketch(this, this.htmlLoc, structure, this.height, this.width);
    };

    return Pad;

  })();

  this.tacit.Pad = Pad;

}).call(this);

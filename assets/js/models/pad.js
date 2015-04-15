// Generated by CoffeeScript 1.4.0
(function() {
  var Pad, _ref;

  if ((_ref = this.tacit) == null) {
    this.tacit = {};
  }

  Pad = (function() {

    function Pad(easel, htmlLoc, height, width, structure) {
      var dim, i, _i, _j, _k, _l, _len, _len1, _len2, _len3, _ref1, _ref2, _ref3, _ref4;
      this.easel = easel;
      this.htmlLoc = htmlLoc;
      this.height = height;
      this.width = width;
      if (structure == null) {
        structure = null;
      }
      if (!(structure != null)) {
        structure = new tacit.Structure;
        new structure.Beam({
          x: 10,
          y: 0
        }, {
          x: 30,
          y: 40
        });
        new structure.Beam({
          x: 30,
          y: 40
        }, {
          x: 80,
          y: 0
        });
        new structure.Beam({
          x: 10,
          y: 0
        }, {
          x: -5,
          y: 110
        });
        new structure.Beam({
          x: -5,
          y: 110
        }, {
          x: 30,
          y: 40
        });
        new structure.Beam({
          x: 30,
          y: 40
        }, {
          x: 100,
          y: 40
        });
        new structure.Beam({
          x: 100,
          y: 40
        }, {
          x: 80,
          y: 0
        });
        new structure.Beam({
          x: 10,
          y: 0
        }, {
          x: 100,
          y: 40
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
        _ref3 = ["y"];
        for (_k = 0, _len2 = _ref3.length; _k < _len2; _k++) {
          dim = _ref3[_k];
          _ref4 = [1, 3, 4];
          for (_l = 0, _len3 = _ref4.length; _l < _len3; _l++) {
            i = _ref4[_l];
            structure.nodeList[i].force[dim] = -100;
          }
        }
      }
      this.sketch = new tacit.Sketch(this, this.htmlLoc, structure, this.height, this.width);
    }

    Pad.prototype.load = function(structure) {
      return this.sketch = new tacit.Sketch(this, this.htmlLoc, structure, this.height, this.width);
    };

    return Pad;

  })();

  this.tacit.Pad = Pad;

}).call(this);

// Generated by CoffeeScript 1.4.0
(function() {
  var Sketch, abs, dist, max, min, pow, print, sqr, sqrt, sum, _ref,
    __slice = [].slice;

  abs = function(n) {
    return Math.abs(n);
  };

  min = function() {
    var n;
    n = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return Math.min.apply(Math, n);
  };

  max = function() {
    var n;
    n = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return Math.max.apply(Math, n);
  };

  pow = function(n, p) {
    return Math.pow(n, p);
  };

  sqr = function(n) {
    return Math.pow(n, 2);
  };

  sqrt = function(n) {
    return Math.sqrt(n);
  };

  sum = function(o) {
    if (o.length) {
      return o.reduce(function(a, b) {
        return a + b;
      });
    } else {
      return "";
    }
  };

  dist = function(a, b) {
    var ai, i;
    return sqrt(sum((function() {
      var _i, _len, _results;
      _results = [];
      for (i = _i = 0, _len = a.length; _i < _len; i = ++_i) {
        ai = a[i];
        _results.push(sqr(ai - (b ? b[i] : 0)));
      }
      return _results;
    })()));
  };

  print = function(o) {
    return console.log(o);
  };

  this.showgrad = {
    checked: false
  };

  this.showforce = {
    checked: true
  };

  this.showzero = {
    checked: true
  };

  this.move = {
    checked: false
  };

  if ((_ref = this.tacit) == null) {
    this.tacit = {};
  }

  Sketch = (function() {

    function Sketch(pad, htmlLoc, structure, height, width) {
      var d, draw, htmlObj, list, maxs, means, mins, n, tool, translate, _i, _len, _ref1, _ref2;
      this.pad = pad;
      if (htmlLoc == null) {
        htmlLoc = "body";
      }
      htmlObj = d3.select(htmlLoc);
      if (structure != null) {
        this.structure = structure;
      } else {
        this.structure = new tacit.Structure;
      }
      this.svg = htmlObj.append("svg:svg").attr("width", width).attr("height", height).attr("pointer-events", "all");
      this.scale = 1;
      this.selectedNodes = this.selectedLinks = [];
      this.blank = this.svg.append("svg:g").attr("transform", "translate(0," + height + ") scale(1,-1)").append("svg:g");
      tool = this.pad.easel;
      this.blank.append("svg:rect").attr("x", -width / 2).attr("y", -height / 2).attr("width", width).attr("height", height).attr("fill", "transparent").on("mousedown", function(d) {
        easel.currentTool.mouseDown(easel, "background", d3.mouse(this), d);
        return false;
      }).on("mousemove", function(d) {
        easel.currentTool.mouseMove(easel, "background", d3.mouse(this), d);
        return false;
      }).on("mouseup", function(d) {
        easel.currentTool.mouseUp(easel, "background", d3.mouse(this), d);
        return false;
      });
      this.nodes = this.blank.selectAll(".node");
      this.links = this.blank.selectAll(".link");
      this.forces = this.blank.selectAll(".force");
      this.grads = this.blank.selectAll(".grad");
      this.dragline = this.blank.append("line").attr("class", "dragline").attr("x1", 0).attr("x2", 0).attr("y1", 0).attr("y2", 0);
      if (structure != null) {
        _ref1 = [{}, {}, {}], mins = _ref1[0], maxs = _ref1[1], means = _ref1[2];
        _ref2 = ["x", "y", "z"];
        for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
          d = _ref2[_i];
          list = (function() {
            var _j, _len1, _ref3, _results;
            _ref3 = structure.nodeList;
            _results = [];
            for (_j = 0, _len1 = _ref3.length; _j < _len1; _j++) {
              n = _ref3[_j];
              _results.push(n[d]);
            }
            return _results;
          })();
          mins[d] = min.apply(null, list);
          maxs[d] = max.apply(null, list);
          means[d] = sum(list) / structure.nodeList.length;
        }
        this.scale = 0.5 * min(width / (maxs.x - mins.x), height / (maxs.y - mins.y));
        translate = [this.scale * means.x, height / 2 - this.scale * means.y];
        this.rescale(translate, this.scale, draw = false);
      }
    }

    Sketch.prototype.rescale = function(translate, scale, draw) {
      if (draw == null) {
        draw = true;
      }
      if (translate == null) {
        translate = d3.event.translate;
      }
      if (scale == null) {
        scale = d3.event.scale;
      }
      this.scale = scale;
      this.blank.attr("transform", "translate(" + translate + ") scale(" + scale + ")");
      if (draw) {
        return this.resize();
      }
    };

    Sketch.prototype.redraw = function() {
      var tool;
      tool = this.pad.easel;
      this.links = this.links.data(this.structure.beamList);
      this.links.enter().insert("line", ".node").attr("class", "link").on("mousedown", function(d) {
        easel.currentTool.mouseDown(easel, "beam", d3.mouse(this), d);
        return false;
      }).on("mousemove", function(d) {
        easel.currentTool.mouseMove(easel, "beam", d3.mouse(this), d);
        return false;
      }).on("mouseup", function(d) {
        easel.currentTool.mouseUp(easel, "beam", d3.mouse(this), d);
        return false;
      });
      this.links.exit().transition().attr("r", 0).remove();
      this.forces = this.forces.data(this.structure.nodeList);
      this.forces.enter().insert("line").attr("class", "force").attr("stroke-width", 0).attr("marker-end", "url(#brtriangle)");
      this.forces.exit().remove();
      this.grads = this.grads.data(this.structure.nodeList);
      this.grads.enter().insert("line").attr("class", "grad").attr("stroke-width", 0).attr("marker-end", "url(#ptriangle)");
      this.grads.exit().remove();
      this.nodes = this.nodes.data(this.structure.nodeList);
      this.nodes.enter().insert("circle").attr("class", "node").attr("r", 5 / this.scale).on("mousedown", function(d) {
        easel.currentTool.mouseDown(easel, "node", d3.mouse(this), d);
        return false;
      }).on("mousemove", function(d) {
        easel.currentTool.mouseMove(easel, "node", d3.mouse(this), d);
        return false;
      }).on("mouseup", function(d) {
        easel.currentTool.mouseUp(easel, "node", d3.mouse(this), d);
        return false;
      }).transition().duration(750).ease("elastic").attr("r", 9 / this.scale);
      this.nodes.exit().transition().attr("r", 0).remove();
      return this.reposition_transition();
    };

    Sketch.prototype.reposition_transition = function() {
      var w,
        _this = this;
      this.structure.solve();
      w = this.structure.nodeList.length / this.structure.lp.obj;
      this.dragline.attr("stroke-width", 10 / this.scale).attr("stroke-dasharray", 10 / this.scale + "," + 10 / this.scale);
      this.links.attr("x1", function(d) {
        return d.source.x;
      }).attr("x2", function(d) {
        return d.target.x;
      }).attr("y1", function(d) {
        return d.source.y;
      }).attr("y2", function(d) {
        return d.target.y;
      }).attr("stroke-dasharray", function(d) {
        if (d.F) {
          return null;
        } else {
          return 10 / _this.scale + "," + 10 / _this.scale;
        }
      }).classed("compression", function(d) {
        return d.f < 0;
      }).classed("tension", function(d) {
        return d.f > 0;
      }).classed("selected", function(d) {
        return _this.selectedLinks.indexOf(d) + 1;
      }).transition().duration(750).ease("elastic").attr("stroke-width", function(d) {
        return 0.035 * d.F || 5 / _this.scale * showzero.checked;
      });
      this.nodes.attr("cx", function(d) {
        return d.x;
      }).attr("cy", function(d) {
        return d.y;
      }).classed("selected", function(d) {
        return _this.selectedNodes.indexOf(d) + 1;
      }).transition().duration(750).ease("elastic").attr("r", function(d) {
        return 18 / _this.scale * (_this.selectedNodes.indexOf(d) + 1 ? 2 : 1);
      });
      this.forces.attr("x1", function(d) {
        return d.x;
      }).attr("x2", function(d) {
        return d.x + d.force.x / 4;
      }).attr("y1", function(d) {
        return d.y;
      }).attr("y2", function(d) {
        return d.y + d.force.y / 4;
      }).attr("stroke-width", function(d) {
        var f;
        if (dist((function() {
          var _ref1, _results;
          _ref1 = d.force;
          _results = [];
          for (d in _ref1) {
            f = _ref1[d];
            _results.push(f);
          }
          return _results;
        })()) > 0) {
          return 10 / _this.scale * showforce.checked;
        } else {
          return 0;
        }
      });
      return this.grads.attr("x1", function(d) {
        return d.x;
      }).attr("x2", function(d) {
        return d.x - 50 / _this.scale * d.grad.x * w;
      }).attr("y1", function(d) {
        return d.y;
      }).attr("y2", function(d) {
        return d.y - 50 / _this.scale * d.grad.y * w;
      }).attr("stroke-width", function(d) {
        var l;
        if (50 / _this.scale * dist((function() {
          var _ref1, _results;
          _ref1 = d.grad;
          _results = [];
          for (d in _ref1) {
            l = _ref1[d];
            _results.push(l);
          }
          return _results;
        })()) * w > 0.05) {
          return 10 / _this.scale * showgrad.checked;
        } else {
          return 0;
        }
      });
    };

    return Sketch;

  })();

  ({
    reposition: function() {
      var w,
        _this = this;
      this.structure.solve();
      this.resize();
      w = this.structure.nodeList.length / this.structure.lp.obj;
      this.dragline.attr("stroke-width", 10 / this.scale).attr("stroke-dasharray", 10 / this.scale + "," + 10 / this.scale);
      this.links.attr("x1", function(d) {
        return d.source.x;
      }).attr("x2", function(d) {
        return d.target.x;
      }).attr("y1", function(d) {
        return d.source.y;
      }).attr("y2", function(d) {
        return d.target.y;
      }).classed("compression", function(d) {
        return d.f < 0;
      }).classed("tension", function(d) {
        return d.f > 0;
      });
      this.nodes.attr("cx", function(d) {
        return d.x;
      }).attr("cy", function(d) {
        return d.y;
      });
      this.forces.attr("x1", function(d) {
        return d.x;
      }).attr("x2", function(d) {
        return d.x + d.force.x / 4;
      }).attr("y1", function(d) {
        return d.y;
      }).attr("y2", function(d) {
        return d.y + d.force.y / 4;
      });
      return this.grads.attr("x1", function(d) {
        return d.x;
      }).attr("x2", function(d) {
        return d.x - 50 / _this.scale * d.grad.x * w;
      }).attr("y1", function(d) {
        return d.y;
      }).attr("y2", function(d) {
        return d.y - 50 / _this.scale * d.grad.y * w;
      });
    },
    resize: function() {
      var w,
        _this = this;
      w = this.structure.nodeList.length / this.structure.lp.obj;
      this.links.attr("stroke-dasharray", function(d) {
        if (d.F) {
          return null;
        } else {
          return 10 / _this.scale + "," + 10 / _this.scale;
        }
      }).attr("stroke-width", function(d) {
        return 0.035 * d.F || 5 / _this.scale * showzero.checked;
      }).classed("selected", function(d) {
        return _this.selectedLinks.indexOf(d) + 1;
      });
      this.nodes.attr("r", function(d) {
        return 18 / _this.scale * (d === _this.selectedNodes.indexOf(d) + 1 ? 2 : 1);
      }).classed("selected", function(d) {
        return _this.selectedNodes.indexOf(d) + 1;
      });
      this.forces.attr("stroke-width", function(d) {
        var f;
        if (dist((function() {
          var _ref1, _results;
          _ref1 = d.force;
          _results = [];
          for (d in _ref1) {
            f = _ref1[d];
            _results.push(f);
          }
          return _results;
        })()) > 0) {
          return 10 / _this.scale * showforce.checked;
        } else {
          return 0;
        }
      });
      return this.grads.attr("stroke-width", function(d) {
        var l;
        if (50 / _this.scale * dist((function() {
          var _ref1, _results;
          _ref1 = d.grad;
          _results = [];
          for (d in _ref1) {
            l = _ref1[d];
            _results.push(l);
          }
          return _results;
        })()) * w > 0.05) {
          return 10 / _this.scale * showgrad.checked;
        } else {
          return 0;
        }
      });
    }
  });

  this.tacit.Sketch = Sketch;

}).call(this);

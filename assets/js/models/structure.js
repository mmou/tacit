// Generated by CoffeeScript 1.4.0
(function() {
  var Beam, Node, Structure, abs, approx, b, beamList, dim, dist, gen_classes, i, isempty, lp, n, nodeList, nodeLookup, pow, print, rt2, s, s2, solveLP, sqr, sqrt, sum, _i, _j, _k, _l, _len, _len1, _len2, _ref, _ref1, _ref2, _ref3, _ref4, _ref5,
    __slice = [].slice;

  abs = function(n) {
    return Math.abs(n);
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

  isempty = function(o) {
    return Object.keys(o).length === 0;
  };

  if ((_ref = window.tacit) == null) {
    window.tacit = {};
  }

  gen_classes = function(nodeLookup, nodeIDLookup, nodeList, beamList, nodes, beams) {
    var Beam, LPresult, LPstring, Node, getNodeIDX, solveLP, strsign;
    Node = (function() {

      function Node(pos) {
        var _base, _name, _name1, _ref1, _ref2, _ref3;
        this.id = nodes++;
        _ref1 = [pos.x, pos.y, pos.z != null ? pos.z : 0], this.x = _ref1[0], this.y = _ref1[1], this.z = _ref1[2];
        this.force = {
          x: 0,
          y: 0,
          z: 0
        };
        this.grad = {
          x: 0,
          y: 0,
          z: 0
        };
        this.fgrad = {
          x: 0,
          y: 0,
          z: 0
        };
        this.fixed = {
          x: false,
          y: false,
          z: !(pos.z != null)
        };
        this.sourced = [];
        this.targeted = [];
        if ((_ref2 = nodeLookup[_name = this.z]) == null) {
          nodeLookup[_name] = {};
        }
        if ((_ref3 = (_base = nodeLookup[this.z])[_name1 = this.y]) == null) {
          _base[_name1] = {};
        }
        if (nodeLookup[this.z][this.y][this.x] != null) {
          throw "a node is already there, aborting.";
        } else {
          nodeLookup[this.z][this.y][this.x] = this.id;
        }
        nodeIDLookup[this.id] = this;
        nodeList.push(this);
      }

      Node.prototype.moveto = function(pos) {
        var d, delta, _i, _len, _ref1;
        delta = {};
        _ref1 = "xyz";
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          d = _ref1[_i];
          if (pos[d] != null) {
            delta[d] = pos[d] - this[d];
          }
        }
        return this.move(delta);
      };

      Node.prototype.move = function(delta) {
        var beam, d, _base, _i, _j, _len, _len1, _name, _name1, _ref1, _ref2, _ref3, _ref4;
        delete nodeLookup[this.z][this.y][this.x];
        if (isempty(nodeLookup[this.z][this.y])) {
          delete nodeLookup[this.z][this.y];
        }
        if (isempty(nodeLookup[this.z])) {
          delete nodeLookup[this.z];
        }
        _ref1 = "xyz";
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          d = _ref1[_i];
          if (delta[d] != null) {
            this[d] += delta[d];
          }
        }
        _ref2 = this.sourced.concat(this.targeted);
        for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
          beam = _ref2[_j];
          beam.update();
        }
        if ((_ref3 = nodeLookup[_name = this.z]) == null) {
          nodeLookup[_name] = {};
        }
        if ((_ref4 = (_base = nodeLookup[this.z])[_name1 = this.y]) == null) {
          _base[_name1] = {};
        }
        return nodeLookup[this.z][this.y][this.x] = this.id;
      };

      Node.prototype.constraints = function() {
        var b, constraints, d, fix, _ref1;
        constraints = {};
        _ref1 = this.fixed;
        for (d in _ref1) {
          fix = _ref1[d];
          constraints[d] = {
            A: ((function() {
              var _i, _len, _ref2, _results;
              _ref2 = this.sourced;
              _results = [];
              for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
                b = _ref2[_i];
                _results.push(b.l[d] / b.L);
              }
              return _results;
            }).call(this)).concat((function() {
              var _i, _len, _ref2, _results;
              _ref2 = this.targeted;
              _results = [];
              for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
                b = _ref2[_i];
                _results.push(-b.l[d] / b.L);
              }
              return _results;
            }).call(this)),
            i: ((function() {
              var _i, _len, _ref2, _results;
              _ref2 = this.sourced;
              _results = [];
              for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
                b = _ref2[_i];
                _results.push(b.id);
              }
              return _results;
            }).call(this)).concat((function() {
              var _i, _len, _ref2, _results;
              _ref2 = this.targeted;
              _results = [];
              for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
                b = _ref2[_i];
                _results.push(b.id);
              }
              return _results;
            }).call(this)),
            b: -this.force[d]
          };
        }
        return constraints;
      };

      Node.prototype["delete"] = function() {
        var beam, pos, _i, _len, _ref1;
        if (!(this.fixed.x || this.fixed.y)) {
          _ref1 = this.sourced.concat(this.targeted);
          for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
            beam = _ref1[_i];
            beam["delete"]();
          }
          pos = nodeList.indexOf(this);
          if (pos + 1) {
            nodeList.splice(pos, 1);
            delete nodeIDLookup[this.id];
            delete nodeLookup[this.z][this.y][this.x];
            if (isempty(nodeLookup[this.z][this.y])) {
              delete nodeLookup[this.z][this.y];
            }
            if (isempty(nodeLookup[this.z])) {
              delete nodeLookup[this.z];
            }
            return delete this;
          }
        }
      };

      return Node;

    })();
    getNodeIDX = function(pt) {
      var lookedup;
      try {
        if (!(pt.x != null)) {
          return pt;
        } else {
          lookedup = nodeLookup[pt.z != null ? pt.z : 0][pt.y][pt.x];
          if (lookedup !== void 0) {
            return lookedup;
          } else {
            throw "node doesn't exist yet";
          }
        }
      } catch (error) {
        return (new Node(pt)).id;
      }
    };
    Beam = (function() {

      function Beam() {
        var pt, pts, _ref1, _ref2;
        pts = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        _ref1 = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = pts.length; _i < _len; _i++) {
            pt = pts[_i];
            _results.push(nodeIDLookup[getNodeIDX(pt)]);
          }
          return _results;
        })(), this.source = _ref1[0], this.target = _ref1[1];
        _ref2 = [0, 0], this.f = _ref2[0], this.F = _ref2[1];
        this.l = {};
        this.update();
        this.grad = {
          x: 0,
          y: 0,
          z: 0
        };
        this.fgrad = {
          x: 0,
          y: 0,
          z: 0
        };
        this.id = beams++;
        this.source.sourced.push(this);
        this.target.targeted.push(this);
        beamList.push(this);
      }

      Beam.prototype.update = function() {
        var d, l, _i, _len, _ref1;
        _ref1 = "xyz";
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          d = _ref1[_i];
          this.l[d] = this.target[d] - this.source[d];
        }
        return this.L = dist((function() {
          var _ref2, _results;
          _ref2 = this.l;
          _results = [];
          for (d in _ref2) {
            l = _ref2[d];
            _results.push(l);
          }
          return _results;
        }).call(this));
      };

      Beam.prototype["delete"] = function() {
        var list, pos, _i, _len, _ref1;
        _ref1 = [this.source.sourced, this.target.targeted, beamList];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          list = _ref1[_i];
          pos = list.indexOf(this);
          if (pos + 1) {
            list.splice(pos, 1);
          }
        }
        return delete this;
      };

      return Beam;

    })();
    LPresult = (function() {

      function LPresult(lp) {
        var dim, dual, i, id, name, prim, _i, _j, _ref1, _ref2, _ref3, _ref4, _ref5;
        this.lp = lp;
        this.obj = glp_get_obj_val(this.lp);
        if (!this.obj) {
          this.obj = 1e6;
        }
        for (i = _i = 1, _ref1 = glp_get_num_cols(lp); 1 <= _ref1 ? _i <= _ref1 : _i >= _ref1; i = 1 <= _ref1 ? ++_i : --_i) {
          _ref2 = [glp_get_col_name(lp, i), glp_get_col_prim(lp, i)], name = _ref2[0], prim = _ref2[1];
          this[name] = prim;
          if (name[0] === "q") {
            _ref3 = [name.slice(1, -1), name.slice(-1)], id = _ref3[0], dim = _ref3[1];
            nodeIDLookup[id].force[dim] = prim;
          }
        }
        for (i = _j = 1, _ref4 = glp_get_num_rows(lp); 1 <= _ref4 ? _j <= _ref4 : _j >= _ref4; i = 1 <= _ref4 ? ++_j : --_j) {
          _ref5 = [glp_get_row_name(lp, i), glp_get_row_dual(lp, i)], name = _ref5[0], dual = _ref5[1];
          if (name.slice(0, 3) !== "abs") {
            this[name] = dual;
          }
        }
      }

      return LPresult;

    })();
    strsign = function(n) {
      if (n > 0) {
        return "+";
      } else {
        return "-";
      }
    };
    LPstring = function() {
      var a, b, beam, c, con, dim, j, lp, node, q, reactionforces, _i, _j, _k, _l, _len, _len1, _len2, _len3, _len4, _m, _ref1, _ref2;
      reactionforces = [];
      lp = "Minimize               \n  obj:" + sum((function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = beamList.length; _i < _len; _i++) {
          beam = beamList[_i];
          _results.push(" + " + beam.L + " F" + beam.id);
        }
        return _results;
      })());
      lp += "\n               \nSubject To";
      for (_i = 0, _len = nodeList.length; _i < _len; _i++) {
        node = nodeList[_i];
        _ref1 = node.constraints();
        for (dim in _ref1) {
          c = _ref1[dim];
          con = "";
          _ref2 = c.A;
          for (j = _j = 0, _len1 = _ref2.length; _j < _len1; j = ++_j) {
            a = _ref2[j];
            if (a !== 0) {
              con += " " + (strsign(a)) + " " + (abs(a)) + " f" + c.i[j] + "                                ";
            }
          }
          if (con) {
            if (!node.fixed[dim]) {
              lp += "\n  n" + node.id + dim + ":" + con + " = " + c.b;
            } else {
              lp += "\n  n" + node.id + dim + ":" + con + " - q" + node.id + dim + " = 0";
              reactionforces.push("q" + node.id + dim);
            }
          }
        }
      }
      for (_k = 0, _len2 = beamList.length; _k < _len2; _k++) {
        b = beamList[_k];
        lp += "\n  absf" + b.id + "p: + f" + b.id + " - F" + b.id + " <= 0               \n  absf" + b.id + "n: - f" + b.id + " - F" + b.id + " <= 0";
      }
      lp += "\n               \nBounds";
      for (_l = 0, _len3 = beamList.length; _l < _len3; _l++) {
        beam = beamList[_l];
        lp += "\n  f" + beam.id + " free               \n  F" + beam.id + " >= 0";
      }
      for (_m = 0, _len4 = reactionforces.length; _m < _len4; _m++) {
        q = reactionforces[_m];
        lp += "\n  " + q + " free";
      }
      lp += "\n               \nEnd\n";
      lp = lp.replace(new RegExp("               ", "g"), "");
      return lp;
    };
    solveLP = function() {
      var lp, smcp;
      lp = glp_create_prob();
      glp_read_lp_from_string(lp, null, LPstring());
      glp_scale_prob(lp, GLP_SF_AUTO);
      smcp = new SMCP({
        presolve: GLP_ON
      });
      glp_simplex(lp, smcp);
      return new LPresult(lp);
    };
    return [Node, Beam, solveLP, LPstring];
  };

  Structure = (function() {

    function Structure(structure) {
      var beam, localnode, node, _i, _j, _len, _len1, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6;
      _ref1 = [{}, {}], this.nodeLookup = _ref1[0], this.nodeIDLookup = _ref1[1];
      _ref2 = [[], []], this.nodeList = _ref2[0], this.beamList = _ref2[1];
      _ref3 = [0, 0], this.nodes = _ref3[0], this.beams = _ref3[1];
      _ref4 = gen_classes(this.nodeLookup, this.nodeIDLookup, this.nodeList, this.beamList, this.nodes, this.beams), this.Node = _ref4[0], this.Beam = _ref4[1], this.solveLP = _ref4[2], this.LPstring = _ref4[3];
      if (structure != null) {
        try {
          _ref5 = structure.beamList;
          for (_i = 0, _len = _ref5.length; _i < _len; _i++) {
            beam = _ref5[_i];
            new this.Beam(beam.source, beam.target);
          }
          _ref6 = structure.nodeList;
          for (_j = 0, _len1 = _ref6.length; _j < _len1; _j++) {
            node = _ref6[_j];
            localnode = this.nodeIDLookup[this.nodeLookup[node.z][node.y][node.x]];
            localnode.fixed = {
              x: node.fixed.x,
              y: node.fixed.y,
              z: node.fixed.z
            };
            localnode.force = {
              x: node.force.x,
              y: node.force.y,
              z: node.force.z
            };
          }
        } catch (error) {

        }
      }
    }

    Structure.prototype.solve = function() {
      var beam, dim, geo, node, rho, sdual, tdual, _i, _j, _k, _l, _len, _len1, _len2, _len3, _ref1, _ref2, _ref3, _ref4, _results;
      try {
        this.lp = this.solveLP();
        _ref1 = this.beamList;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          beam = _ref1[_i];
          beam.f = this.lp["f" + beam.id];
          beam.F = abs(beam.f);
        }
        _ref2 = this.beamList;
        for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
          beam = _ref2[_j];
          _ref3 = "xyz";
          for (_k = 0, _len2 = _ref3.length; _k < _len2; _k++) {
            dim = _ref3[_k];
            rho = beam.f / beam.L;
            geo = 1 - 2 * Math.pow(beam.l[dim] / beam.L, 2);
            sdual = this.lp["n" + beam.source.id + dim] || 0;
            tdual = this.lp["n" + beam.target.id + dim] || 0;
            beam.fgrad[dim] = rho * geo * (sdual - tdual);
          }
        }
        _ref4 = this.nodeList;
        _results = [];
        for (_l = 0, _len3 = _ref4.length; _l < _len3; _l++) {
          node = _ref4[_l];
          _results.push((function() {
            var _len4, _m, _ref5, _results1;
            _ref5 = "xyz";
            _results1 = [];
            for (_m = 0, _len4 = _ref5.length; _m < _len4; _m++) {
              dim = _ref5[_m];
              node.fgrad[dim] = sum((function() {
                var _len5, _n, _ref6, _results2;
                _ref6 = node.sourced;
                _results2 = [];
                for (_n = 0, _len5 = _ref6.length; _n < _len5; _n++) {
                  beam = _ref6[_n];
                  _results2.push(beam.fgrad[dim]);
                }
                return _results2;
              })());
              _results1.push(node.fgrad[dim] -= sum((function() {
                var _len5, _n, _ref6, _results2;
                _ref6 = node.targeted;
                _results2 = [];
                for (_n = 0, _len5 = _ref6.length; _n < _len5; _n++) {
                  beam = _ref6[_n];
                  _results2.push(beam.fgrad[dim]);
                }
                return _results2;
              })()));
            }
            return _results1;
          })());
        }
        return _results;
      } catch (error) {

      }
    };

    Structure.prototype.solvegrad = function(nodeList) {
      var eps, node, xdiff, ydiff, _i, _len, _results;
      eps = 1e-4;
      try {
        _results = [];
        for (_i = 0, _len = nodeList.length; _i < _len; _i++) {
          node = nodeList[_i];
          node.move({
            x: eps
          });
          xdiff = (this.solveLP().obj - this.lp.obj) / eps;
          node.move({
            x: -eps,
            y: eps
          });
          ydiff = (this.solveLP().obj - this.lp.obj) / eps;
          node.move({
            y: -eps
          });
          _results.push(node.grad = {
            x: -xdiff,
            y: -ydiff,
            z: 0
          });
        }
        return _results;
      } catch (error) {

      }
    };

    return Structure;

  })();

  print("Testing tacit.Structure...");

  approx = function(a, b) {
    return 1e-10 >= abs(a - b) / (abs(a) + abs(b));
  };

  s = new Structure;

  _ref1 = [s.nodeList, s.nodeLookup, s.beamList], nodeList = _ref1[0], nodeLookup = _ref1[1], beamList = _ref1[2];

  _ref2 = [s.Node, s.Beam, s.solveLP], Node = _ref2[0], Beam = _ref2[1], solveLP = _ref2[2];

  n = new Node({
    x: 0,
    y: 0
  });

  n.fixed.x = true;

  if (nodeList[nodeLookup[0][0][0]].fixed.x !== true) {
    print("Failed Test 1");
  }

  n.fixed.x = false;

  b = new Beam({
    x: 0,
    y: 0
  }, {
    x: 1,
    y: 1
  });

  if (beamList[0] !== b) {
    print("Failed Test 3.0");
  }

  if (b.source.id !== 0 || b.target.id !== 1) {
    print("Failed Test 3.1");
  }

  if (nodeList[0].sourced[0].id !== 0) {
    print("Failed Test 3.2");
  }

  if (nodeList[1].targeted[0].id !== 0) {
    print("Failed Test 3.3");
  }

  new Beam({
    x: 1,
    y: 1
  }, {
    x: 2,
    y: 0
  });

  rt2 = sqrt(2);

  if (nodeList[1].constraints().x.i[0] !== 1) {
    print("Failed Test 4.0");
  }

  if (nodeList[1].constraints().x.i[1] !== 0) {
    print("Failed Test 4.1");
  }

  if (!approx(nodeList[1].constraints().x.A[0], rt2 / 2)) {
    print("Failed Test 4.2");
  }

  if (!approx(nodeList[1].constraints().x.A[1], -rt2 / 2)) {
    print("Failed Test 4.3");
  }

  if (!approx(nodeList[1].constraints().y.A[0], -rt2 / 2)) {
    print("Failed Test 4.4");
  }

  if (!approx(nodeList[1].constraints().y.A[1], -rt2 / 2)) {
    print("Failed Test 4.5");
  }

  _ref3 = ["x", "y"];
  for (_i = 0, _len = _ref3.length; _i < _len; _i++) {
    dim = _ref3[_i];
    _ref4 = [0, 2];
    for (_j = 0, _len1 = _ref4.length; _j < _len1; _j++) {
      i = _ref4[_j];
      nodeList[i].fixed[dim] = true;
    }
  }

  nodeList[1].force.y = -1;

  lp = solveLP();

  if (!approx(lp.obj, 2)) {
    print("Failed Test 5.0");
  }

  if (!approx(lp.f0, -rt2 / 2)) {
    print("Failed Test 5.1");
  }

  if (!approx(lp.f0, lp.f1)) {
    print("Failed Test 5.2");
  }

  s2 = new Structure;

  new s2.Beam({
    x: 0,
    y: 0,
    z: 0
  }, {
    x: 1,
    y: 0
  });

  new s2.Beam({
    x: 0,
    y: 0,
    z: 0
  }, {
    x: -1,
    y: 0
  });

  new s2.Beam({
    x: 0,
    y: 0,
    z: 0
  }, {
    x: 0,
    y: 1
  });

  new s2.Beam({
    x: 0,
    y: 0,
    z: 0
  }, {
    x: 0,
    y: -1
  });

  _ref5 = ["x", "y"];
  for (_k = 0, _len2 = _ref5.length; _k < _len2; _k++) {
    dim = _ref5[_k];
    for (i = _l = 1; _l <= 4; i = ++_l) {
      s2.nodeList[i].fixed[dim] = true;
    }
  }

  s2.nodeList[0].force = {
    x: 1,
    y: 1,
    z: 1
  };

  s2.nodeList[0].move({
    z: 1
  });

  if (!approx(s2.solveLP().obj, 4)) {
    print("Failed Test 6");
  }

  print("                       ...testing complete.");

  window.tacit.Structure = Structure;

}).call(this);

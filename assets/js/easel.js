function Easel() {

    this.pad = new Pad();
    this.toolbar = new Toolbar(this);
    this.currentTool;
    this.toolUseHistory = {};

    this.load = function(sketch) {
    	this.pad.load(sketch)
    }

}
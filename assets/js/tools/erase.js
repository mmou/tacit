function Erase(toolbar) {
    
	this.toolbar = toolbar;

    this.name = "Erase Tool";
    this.cursor = "assets/resources/cursor-images/eraser.png";

    this.undo = function() {
        return null;
    };

    this.makeCurrent = function() {
        this.toolbar.easel.currentTool = this;
    };

    // Write event handlers here
}
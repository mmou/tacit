function Draw(toolbar) {
    
	this.toolbar = toolbar;

    this.name = "Draw Tool";
    this.cursor = "assets/resources/cursor-images/pencil.png";

    this.undo = function() {
        return null;
    };

    this.makeCurrent = function() {
        this.toolbar.easel.currentTool = this;
    };

    // Write event handlers here
}
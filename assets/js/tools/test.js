function Test(toolbar) {

	this.toolbar = toolbar;
	
    this.name = "Test Tool";
    this.cursor;

    this.undo = function() {
        return null;
    };

    this.makeCurrent = function() {
        this.toolbar.easel.currentTool = this;
    };

    // Write event handlers here
}
function Pad() {
    
    this.sketch;

    this.analyze = function() {
        this.sketch.analyze();
    };

    this.update = function() {
        this.sketch.update();
    };

    this.load = function(newSketch) {
    	this.sketch = newSketch;
    	this.update();
    }

    // Write event handlers here
}
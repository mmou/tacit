function Toolbar(easel) {

	this.easel = easel;

    this.draw = new Draw(this);
    this.erase = new Erase(this);
    this.measure = new Measure(this);
    this.select = new Select(this);
    this.test = new Test(this);
    
}
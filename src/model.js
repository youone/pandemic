class Model {

    constructor(name, type, N0, Rstart, Rend, width, color) {
        this.name = name;
        this.type = type;
        this.N0 = N0;
        this.Rstart = Rstart;
        this.Rend = Rend;
        this.width = width;
        this.color = color;
        this.scale = 1;
        this.shift = 0;
        this.tau = 
    }

    scale(value) {
        this.scale = value;
    }

    shift(value) {
        this.shift = value;
    }

    infected(n, R, tau, Rstart) {
        return this.N0*(Math.exp(Math.log(this.R)/this.tau));
    }
    


}
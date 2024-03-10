import {wasm} from '../.';

wasm().then(module => {
    console.log(module.lerp(1,2,3));
})

export class PandemicModel extends HTMLElement {

    constructor(name, type, N0, Rstart, Rend, start, width, color) {
        super();

        this.name = name;
        this.type = type;
        this.N0 = N0;
        this.Rstart = Rstart;
        this.Rend = Rend;
        this.start = start;
        this.width = width;
        this.color = color;
        this.scale = 1;
        this.shift = 0;
        this.tau = 0;
        this.onChangeHandlers = [];
        this.onSelectHandlers = [];
        this.days = Array.from({length: 200}, (_, i) => i + 1);
        this.rData = [];
        this.nInfected = [];
    }

    connectedCallback() {
        const template = /*html*/`
            <style>
                #content {
                    width: 100px;
                    height: 40px;
                    background-color: lightgrey;
                    margin: 5px;
                    cursor: pointer;
                }
            </style>
            <div id="content">${this.name}</div>
        `;

        this.shadow = this.attachShadow({mode: 'open'});
        this.shadow.innerHTML = template;

        this.content = this.shadow.querySelector('#content');

        this.content.addEventListener('click', (event) => {
            this.onSelectHandlers.forEach(h => h(this));
            ;
        })
    }

    rExponential(d, slope) {
        slope = -Math.log(1/this.Rstart)/this.width;
        console.log(slope);
        return d <= this.start ? this.Rstart : this.Rend + (this.Rstart-this.Rend)*Math.exp(-slope*(d-this.start));
        // return Rstart;
    }

    rLinear(d) {
        if (d <= this.start) {
            return this.Rstart;
        }
        else if (d > (this.start + this.width)) {
            return this.Rend;
        }
        else {
            return this.Rstart - (d-this.start) * (this.Rstart - this.Rend)/this.width;
        }
    }

    infectionModel(n, R, tau, Rstart) {
        return n*(Math.exp(Math.log(R)/tau));
        // console.log(  (Math.pow((Rstart),(1/tau))-1)  );
        // return (Math.pow((Rstart),(1/tau))-1) * n * (Math.exp(Math.log(R)/tau));
    }
    
    setR(type, value) {
        if (type === 'start') this.start = value;
        if (type === 'stop') this.width = value  - this.start;
        this.update();
    }

    update() {
        // this.rData = this.days.map((d) => ({day: d, value: this.rExponential(d, 0.5)}));
        this.rData = this.days.map((d) => ({day: d, value: this.rLinear(d)}));

        let n = 1;
        this.nInfected = this.rData.map(r => {
            n = this.infectionModel(n, r.value, 5, 3);
            const nNew = (Math.pow((3),(1/5))-1) * n;
            return {day: r.day, value: nNew};
        })

        this.onChangeHandlers.forEach(h => h(this));
        // setTimeout(() => {
        //     this.onChangeHandlers.forEach(h => h(this));
        // }, 0);
    
        // this.onChangeHandlers.forEach(h => h(this));
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

    onChange(handler) {
        this.onChangeHandlers.push(handler);
    }

    onSelect(handler) {
        this.onSelectHandlers.push(handler);
    }

}

window.customElements.define('pandemic-model', PandemicModel)
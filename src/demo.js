import {wasm} from '../.';
import * as d3 from 'd3';
import $ from "jquery";
import interact from "interactjs";
import whoData from '../data/data.csv'

wasm().then(module => {
    console.log(module.lerp(1,2,3));
})

$(document).ready(() => {
    const pdp1 = new PandemicPlot(200, 'rvalue');
    const pdp2 = new PandemicPlot(400, 'cases');

    pdp1.onParameterChange(nInfected => {
        pdp2.update(nInfected);
    })
    $('body').append(pdp1);
    $('body').append(pdp2);

    pdp1.update([{day: 1, value: 3},{day: 2, value: 3},{day: 3, value: 3}])
})

function rExponential(d, Rstart, Rend, tOnset, slope) {
    // const r = [];
    // days.forEach(d => {
    //     r.push(d<=tOnset ? Rstart : Rend + (Rstart-Rend)*Math.exp(-slope*(d-tOnset)))
    // })
    // return r;
    return d<=tOnset ? Rstart : Rend + (Rstart-Rend)*Math.exp(-slope*(d-tOnset));
}

function infectionModel(n, R, tau, Rstart) {
    return n*(Math.exp(Math.log(R)/tau));
    // console.log(  (Math.pow((Rstart),(1/tau))-1)  );
    // return (Math.pow((Rstart),(1/tau))-1) * n * (Math.exp(Math.log(R)/tau));
}

export class PandemicPlot extends HTMLElement {

    constructor(height, type) {
        super()
        this.nBins = 200;
        this.plotHeight = height;
        this.type = type;
        this.parameterChangeHandler = () => {};
    }

    connectedCallback() {
        const template = `
            <style>
                .rcontrol {
                    cursor: pointer !important;
                }
            </style>
            <div id="content"></div>
        `;

        this.innerHTML = template;

        this.elements = {};
        $(this).find('*').get().filter(e => e.getAttribute('id') !== null).forEach(e => {
            this.elements[e.getAttribute('id')] = $(e);
        });

        const margin = {top: 10, right: 20, bottom: 30, left: 50},
            width = 600 - margin.left - margin.right;
        this.height = this.plotHeight - margin.top - margin.bottom;

        //x and y scales generators
        this.xScale = d3.scaleLinear().range([0, width]).domain([0, this.nBins]);
        this.yScale = d3.scaleLinear().range([this.height, 0]).domain([0, this.type === 'rvalue' ? 5 : 10000]);

        //x and y axes generators
        this.xAxis = d3.axisBottom().scale(this.xScale);
        this.yAxis = d3.axisLeft().scale(this.yScale);

        this.svg = d3.select(this.elements.content[0]).append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", this.height + margin.top + margin.bottom)
            .append("g")
            .attr("transform",
                "translate(" + margin.left + "," + margin.top + ")");

        this.svg.append("g")
            .attr("class", "x axis")
            .attr("transform", "translate(0," + this.height + ")")
            .call(this.xAxis);

        this.svg.append("g")
            .attr("class", "y axis")
            .call(this.yAxis);

        console.log(this.xScale.invert(0));

        if (this.type !== 'rvalue') return;

        const rControl = this.svg.selectAll("polygon")
            .data([[{"x":-2, "y":0},
                {"x":0,"y":4},
                {"x":2,"y":0}]])
            .enter().append("polygon")
            .attr("class", "rcontrol")
            .attr("points", "-5,-10 0,0 5,-10")
            .attr("stroke","black")
            .attr("stroke-width",2);

        interact(rControl.node())
            // interact(mainContentDiv)
            .draggable({
                modifiers: [
                    // interact.modifiers.restrictRect({
                    //     restriction: 'parent',
                    // })
                ],
                listeners: {
                    start: (event) => {
                    },
                    move: (event) => {
                        const x = (parseFloat(event.target.getAttribute('data-x')) || 0) + event.dx;
                        event.target.style.transform = `translate(${x}px,0)`
                        event.target.setAttribute('data-x', x)
                        const days = Array.from({length: 200}, (_, i) => i + 1);
                        const rData = days.map((d) => ({day: d, value: rExponential(d, 3, 0.7, this.xScale.invert(x), 0.5)}));
                        this.update(rData);

                        let n = 1;
                        this.nInfected = rData.map(r => {
                            n = infectionModel(n, r.value, 5, 3);
                            const nNew = (Math.pow((3),(1/5))-1) * n;
                            return {day: r.day, value: nNew};
                        })

                        this.parameterChangeHandler(this.nInfected);
                    },
                    end: (event) => {
                        // this.nInfected.forEach(d => console.log(Math.round(d)));
                        // this.parameterChangeHandler(this.nInfected);
                    }
                }
            })
        interact(rControl.node()).styleCursor(false)
    }

    update(data) {

        const dta = data;

        $(this).find('.datapath').remove();

        this.svg.append("path")
            .datum(dta)
            .attr("class", "datapath")
            .attr("fill", "none")
            .attr("stroke", "steelblue")
            .attr("stroke-width", 1.5)
            .attr("d", d3.line()
                .x((d) => {
                    // console.log(d);
                    return this.xScale(d.day);
                })
                .y((d) =>  {
                    return this.yScale(d.value);
                })
            )
    }

    onParameterChange(handler) {
        this.parameterChangeHandler = handler;
    }

}

window.customElements.define('pandemic-plot', PandemicPlot);



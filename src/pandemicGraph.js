import * as d3 from 'd3';
import interact from "interactjs";

export class PandemicPlot extends HTMLElement {

    constructor(height, type) {
        super()
        this.nBins = 200;
        this.plotHeight = height;
        this.type = type;
        // this.ymax = ymax;
        this.models = {};
        this.margin = {top: 10, right: 20, bottom: 30, left: 50};

    }

    addModel(name, model) {
        model.name = name;
        this.models[name] = {model: model};
        this.models[name].brushes = {};
        this.models[name].path = null;
        this.models[name].selected = false;

        model.onSelect((m) => {
            this.selectModel(m.name);
        });
    
        // model.onChange((parameters) => {
        //     console.log('MODEL CHANGED', parameters);
        // })
    }

    update() {
        Object.values(this.models).forEach(m => {
            m.model.update();
        });        
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

        this.shadow = this.attachShadow({mode: 'open'});
        this.shadow.innerHTML = template;
        this.content = this.shadow.querySelector('#content');

        this.width = 600 - this.margin.left - this.margin.right;
        this.height = this.plotHeight - this.margin.top - this.margin.bottom;

        //x and y scales generators
        this.xScale = d3.scaleLinear().range([0, this.width]).domain([0, this.nBins]);
        this.yScale = d3.scaleLinear().range([this.height, 0]).domain([0, this.type === 'rvalue' ? 5 : 10]);

        //x and y axes generators
        this.xAxis = d3.axisBottom().scale(this.xScale);
        this.yAxis = d3.axisLeft().scale(this.yScale);

        this.svg = d3.select(this.content).append("svg")
            .attr("width", this.width + this.margin.left + this.margin.right)
            .attr("height", this.height + this.margin.top + this.margin.bottom)
            .append("g")
            .attr("transform",
                "translate(" + this.margin.left + "," + this.margin.top + ")");

        this.svg.append("g")
            .attr("class", "x-axis")
            .attr("transform", "translate(0," + this.height + ")")
            .call(this.xAxis);

        this.svg.append("g")
            .attr("class", "y-axis")
            .call(this.yAxis);

        console.log(this.xScale.invert(0));

        if (this.type !== 'rvalue') return;

    }


    // update(data) {

    //     const dta = data;

    //     document.querySelector('.datapath').remove();

    //     if (this.type === 'cases') {
    //         const maxValue = d3.max(dta.map(d => d.value));
    //         console.log(maxValue);
    //         this.yScale.domain([0, 1.5*maxValue]);
    //         this.svg.select(".y-axis")
    //         .call(this.yAxis);
    //     }


    //     this.svg.append("path")
    //         .datum(dta)
    //         .attr("class", "datapath")
    //         .attr("fill", "none")
    //         .attr("stroke", "steelblue")
    //         .attr("stroke-width", 1.5)
    //         .attr("d", d3.line()
    //             .x((d) => {
    //                 // console.log(d);
    //                 return this.xScale(d.day);
    //             })
    //             .y((d) =>  {
    //                 return this.yScale(d.value);
    //             })
    //         )
    // }

    // onParameterChange(handler) {
    //     this.parameterChangeHandler = handler;
    // }

}

export class PandemicRPlot extends PandemicPlot {

    constructor() {
        super(200, 'rvalue')
    };

    addModel(name, model) {
        super.addModel(name, model);

        model.onChange((mod) => {
            console.log('MODEL CHANGED R', mod);

            Object.values(this.models).forEach(m => {
                const dta = m.model.rData;
                
                if (m.path) m.path.node().remove();

                m.path = this.svg.append("path")
                .datum(dta)
                .attr("class", "datapath")
                .attr("fill", "none")
                .attr("stroke", "steelblue")
                .attr("stroke-width", m.selected ? 3 : 1.5)
                .attr("d", d3.line()
                    .x((d) => {
                        // console.log(d);
                        return this.xScale(d.day);
                    })
                    .y((d) =>  {
                        return this.yScale(d.value);
                    })
                )
            });

        })

        const brush = d3.brushX()
        // .extent([[this.margin.left, this.margin.top], [this.width - this.margin.right, this.height - this.margin.bottom]])
        .extent([[0, 0], [this.width, 30]])
        .on("start brush end", (event) => {
            if (!event.sourceEvent) return;
            const selection = event.selection;
            const [x0, x1] = selection.map(this.xScale.invert);
            console.log(x0, x1);
            this.selectedModel.model.setR('start', x0);
            this.selectedModel.model.setR('stop', x1);
            this.selectedModel.brushes.rBrush.call(brush.move, [Math.round(x0), Math.round(x1)].map(this.xScale));
        });

        const rBrush = this.svg.append("g")
        .attr("transform", "translate(0,-20)")
        .call(brush)
        .call(brush.move, [model.start, model.start + model.width].map(this.xScale))
        // .call(g => g.select(".overlay")
        //     .datum({type: "selection"})
        //     .on("mousedown touchstart", () => {}));

        this.models[name].brushes.rBrush = rBrush;

        this.selectModel(name);
    }

    selectModel(name) {
        this.selectedModel = this.models[name];
        Object.values(this.models).forEach(m => {
            m.selected = m.model.name === name ? true : false
            m.brushes.rBrush.node().style.display = m.model.name === name ? 'block' : 'none';
            if (m.path) m.path.node().setAttribute('stroke-width', m.model.name === name ? 3 : 1.5);
        })
    }

    // makeRControl(classname, position, model) {

    //     const pos = this.xScale(position);
    //     const rControl = this.svg
    //         .data([[{"x":pos-5, "y":-10},
    //             {"x":pos,"y":0},
    //             {"x":pos+5,"y":-10}]])
    //         .append("polygon")
    //         .attr("class", `rcontrol ${classname}`)
    //         .attr("points", d => `${d[0].x},${d[0].y} ${d[1].x},${d[1].y} ${d[2].x},${d[2].y}`)
    //         .attr("stroke","black")
    //         .attr("stroke-width",2);

    //     interact(rControl.node())
    //         // interact(mainContentDiv)
    //         .draggable({
    //             modifiers: [
    //                 // interact.modifiers.restrictRect({
    //                 //     restriction: 'parent',
    //                 // })
    //             ],
    //             listeners: {
    //                 start: (event) => {
    //                 },
    //                 move: (event) => {
    //                     const x = (parseFloat(event.target.getAttribute('data-x')) || 0) + event.dx;
    //                     event.target.style.transform = `translate(${x}px,0)`
    //                     event.target.setAttribute('data-x', x)
    //                     model.setR(classname, this.xScale.invert(x) + position);

    //                     // const days = Array.from({length: 200}, (_, i) => i + 1);
    //                     // const rData = days.map((d) => ({day: d, value: rExponential(d, 3, 0.7, this.xScale.invert(x), 0.5)}));
    //                     // // this.update(rData);

    //                     // let n = 1;
    //                     // this.nInfected = rData.map(r => {
    //                     //     n = infectionModel(n, r.value, 5, 3);
    //                     //     const nNew = (Math.pow((3),(1/5))-1) * n;
    //                     //     return {day: r.day, value: nNew};
    //                     // })

    //                     // this.parameterChangeHandler(this.nInfected);
    //                 },
    //                 end: (event) => {
    //                     // this.nInfected.forEach(d => console.log(Math.round(d)));
    //                     // this.parameterChangeHandler(this.nInfected);
    //                 }
    //             }
    //         })

    //     interact(rControl.node()).styleCursor(false)

    //     return rControl;
    // }
}

export class PandemicCasePlot extends PandemicPlot {
    constructor() {
        super(400, 'cases')
    };

    addModel(name, model) {
        super.addModel(name, model);

        model.onChange((mod) => {
            console.log('MODEL CHANGED C', mod);

            console.log(mod.name);

            let maxValue = 0;
            let maxVal;

            Object.values(this.models).forEach(m => {
                const dta = m.model.nInfected;
                maxVal = d3.max(dta.map(d => d.value));
                if (maxVal > maxValue) maxValue = maxVal;
                console.log(maxValue);
            })

            Object.values(this.models).forEach(m => {

                const dta = m.model.nInfected;

                this.yScale.domain([0, 1.5*maxValue]);
                this.svg.select(".y-axis")
                .call(this.yAxis);

                if (m.path) m.path.node().remove();

                m.path = this.svg.append("path")
                    .datum(dta)
                    .attr("class", `datapath ${mod.name}`)
                    .attr("fill", "none")
                    .attr("stroke", "steelblue")
                    .attr("stroke-width", m.selected ? 3 : 1.5)
                    .attr("d", d3.line()
                        .x((d) => {
                            // console.log(d);
                            return this.xScale(d.day);
                        })
                        .y((d) =>  {
                            // console.log(d);
                            return this.yScale(d.value);
                        })
                    )
            })
        })
    }

    selectModel(name) {
        this.selectedModel = this.models[name];
        Object.values(this.models).forEach(m => {
            m.selected = m.model.name === name ? true : false
            m.path.node().setAttribute('stroke-width', m.model.name === name ? 3 : 1.5);
        })
    }


}

window.customElements.define('pandemic-plot', PandemicPlot);
window.customElements.define('pandemic-rplot', PandemicRPlot);
window.customElements.define('pandemic-caseplot', PandemicCasePlot);



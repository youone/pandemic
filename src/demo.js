import {PandemicRPlot, PandemicCasePlot} from './pandemicGraph';
import {PandemicModel} from './pandemicModel';


window.addEventListener('DOMContentLoaded',function () {
    const rGraph = new PandemicRPlot();
    const cGraph = new PandemicCasePlot();

    // pdp1.onParameterChange(nInfected => {
    //     pdp2.update(nInfected);
    // })

    document.body.appendChild(rGraph);
    document.body.appendChild(cGraph);

    const pandemicModel1 = new PandemicModel('test1', 'type', 10, 3, 0.7, 50, 10, 'red');
    const pandemicModel2 = new PandemicModel('test2', 'type', 10, 3, 0.7, 55, 10, 'blue');

    rGraph.addModel('mod1', pandemicModel1);
    cGraph.addModel('mod1', pandemicModel1);
    pandemicModel1.update();
    rGraph.addModel('mod2', pandemicModel2);
    cGraph.addModel('mod2', pandemicModel2);
    pandemicModel2.update();
    cGraph.update();

    document.body.appendChild(pandemicModel1);
    document.body.appendChild(pandemicModel2);

});

// $(document).ready(() => {

//     const pdp1 = new PandemicPlot(200, 'rvalue');
//     const pdp2 = new PandemicPlot(400, 'cases');

//     pdp1.onParameterChange(nInfected => {
//         pdp2.update(nInfected);
//     })
//     $('body').append(pdp1);
//     $('body').append(pdp2);

//     pdp1.update([{day: 1, value: 3},{day: 2, value: 3},{day: 3, value: 3}])
// })


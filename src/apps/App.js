import Core from './Core';
import Random from '../utils/Random';

let glsl = require( 'glslify' );

const mat4 = require('gl-mat4')

export default class App extends Core {
    constructor ( container ) {
        super( container, .5, true ); // container, scale factor (downsample canvas), debug?
        this.create();
        this.start();
    }

    create () {
        let vs = glsl( '../glsl/shader.vert' );
        let fs = glsl( '../glsl/shader.frag' );

        let s = 1.0;

        this.cube = {
            position: [
                // front quad
                [-s, s, -s],
                [s, s, -s],
                [s, -s, -s],
                [-s, -s, -s],

                // right quad
                [s, s, s],
                [s, -s, s],

                // left quad
                [-s, s, s],
                [-s, -s, s]

            ],
            color: [
                // front quad
                [1, 0, 0],
                [0, 1, 0],
                [0, 0, 1],
                [0, 0, 0],
                
                // right quad
                [0, 1, 0],
                [0, 0, 1],

                // left quad
                [1, 0, 0],
                [0, 0, 1]
            ],
            elements: [
                [
                    0, 1, 2, 2, 3, 0, // front quad
                    1, 4, 5, 5, 2, 1, // left quad
                    0, 6, 7, 7, 3, 0, // right quad
                    6, 4, 7, 7, 5, 4, // back quad
                    0, 6, 1, 1, 6, 4, // top quad
                    3, 2, 7, 7, 2, 5 // bottom quad
                ]
            ]
        }

        this.draw = this.regl({
            vert: vs,
            frag: fs,
            viewport: this.viewport,
            attributes: {
                position: this.cube.position,
                color: this.cube.color
            }, 
            
            uniforms: {
                time: this.regl.prop( 'time' ),
                model: mat4.identity([]),
                view: mat4.lookAt(
                    [],
                    [0, 0, -8.0],
                    [0, 0, 0.0],
                    [0, 1, 0]),
                projection: mat4.perspective([],
                    45,
                    this.ratio,
                    0.01,
                    1000)
            },
            
            elements: this.cube.elements
        });
    }

    update() {
        super.update();
    }

    render () {
        super.render();
        this.draw( {
            time: this.timer.getTimeS()
        } );
    }
}
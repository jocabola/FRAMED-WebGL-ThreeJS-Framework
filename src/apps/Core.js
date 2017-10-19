let Stats = require( 'stats-js' );

import regl from 'regl';
import GLParams from '../gfx/utils/GLParams'
import Timer from '../utils/Timer'

export default class Core {
    constructor( container, scale=1.0, debug=false ) {
        let w = 1080;
        let h = 1920;

        this.scale = scale;
        
        this.width = w * this.scale;
        this.height = h * this.scale;
        this.ratio = w/h;

        console.log( "App init" );

        this.container = container;

        this.regl = regl( {
            container: container
            // extensions: ['webgl_draw_buffers', 'oes_texture_float']
        } );
        this.viewport = {
            x: 0,
            y: 0,
            width: this.width,
            height: this.height
        }

        // GL Params (can be useful for GPGPU and other stuff)
        this.glParams = new GLParams( this.regl._gl );
        console.log( this.glParams); // dump

        this.canvas = container.children[0];

        this.resize();

        // -- settings ---
        this.debug = debug;

        // -- debugg stuff here ---

        let stats = new Stats();
        stats.domElement.style.position = 'absolute';
        stats.domElement.style.left = '0';
        stats.domElement.style.top = '0';
        if ( this.debug ) document.body.appendChild( stats.domElement );
        this.stats = stats;

        let onResize = (evt) => {
            this.resize();
        }

        // window.addEventListener( "resize", onResize, false );
    }

    start () {
        // -- Launch APP ---
        this.timer = new Timer();

        let animate = () => {
            requestAnimationFrame( animate );
            if ( this.debug ) this.stats.begin();
            this.update();
            this.render();
            if ( this.debug ) this.stats.end();
        }

        animate();
    }
    
    update () {
        this.timer.update();
    }

    render () {
        this.regl.clear({
            color: [0, 0, 0, 1],
            depth: 1
        });
    }

    pause () {
        this.paused = true;
    }

    play () {
        this.paused = false;
    }

    resize () {
        let w = this.width;
        let h = this.height;

        let ww = window.innerWidth;
        let wh = window.innerHeight;
        
        let vw = ww;
        let vh = ww / this.ratio;
        if (vh > wh) {
            vh = wh;
            vw = vh * this.ratio;
        }
        
        this.canvas.width = w;
        this.canvas.height = h;
        this.canvas.style.width = `${vw}px`;
        this.canvas.style.height = `${vh}px`;
    }
}
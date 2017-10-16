let Stats = require( 'stats-js' );

import {WebGLRenderer, PerspectiveCamera, Scene} from 'three';
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

        // -- Renderer ---
        this.renderer = new WebGLRenderer( { antialias: true, alpha: true } );
        this.renderer.setClearColor( 0x000000, 1 );

        // camera
        this.camera = new PerspectiveCamera( 45, w/h, 1, 10000 );
        this.scene = new Scene();
        this.scene.add( this.camera );

        // GL Params (can be useful for GPGPU and other stuff)
        this.glParams = new GLParams( this.renderer.context );
        console.log( this.glParams); // dump

        this.renderer.setSize( this.width, this.height );
        this.resize();
        
        container.appendChild( this.renderer.domElement );

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

        window.addEventListener( "resize", onResize, false );
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
        this.renderer.clear();
        this.renderer.render( this.scene, this.camera );
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
        
        this.renderer.domElement.style.width = `${vw}px`;
        this.renderer.domElement.style.height = `${vh}px`;
    }
}
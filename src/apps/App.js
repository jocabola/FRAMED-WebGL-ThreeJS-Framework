import Core from './Core';
import Random from '../utils/Random';
import {BoxBufferGeometry, Mesh, MeshNormalMaterial} from 'three';

export default class App extends Core {
    constructor ( container ) {
        super( container, .5, true ); // container, scale factor (downsample canvas), debug?

        let N_BOXES = 500;
        let mat = new MeshNormalMaterial();
        let geo = new BoxBufferGeometry(1, 1, 1);

        // init Random
        let rnd = new Random(); // starts with default seed 0

        this.boxes = [];

        for ( let i=0;i<N_BOXES; i++ ) {
            let box = new Mesh( geo, mat );
            box.position.set ( rnd.randi(-20,20), rnd.randi(-20,20), rnd.randi(-250, -50));
            box.startTime = i;
            box.delay = rnd.randf(0, 1000000);
            box.speed = { y: rnd.randf( .2, .6 ), z: rnd.randf( .2, .6 ) };
            this.scene.add( box );
            this.boxes.push( box );
            box.visible = false;
        }

        this.start();

    }

    update() {
        super.update();
        
        for ( let box of this.boxes ) {
            box.visible = this.timer.getTimeMs() > box.startTime;
            if ( box.visible ) {
                let t = box.delay + this.timer.getTimeS();

                let s = 1.0;
                let sd = 500;

                if ( this.timer.getTimeMs() < box.startTime + sd ) {
                    s = (this.timer.getTimeMs()-box.startTime)/sd;
                }

                box.scale.set( s, s, s );

                let w = box.position.z < -100 ? 50 : 20; //box.position.z * .4;
                box.position.set( w * Math.sin( t * box.speed.y * .01 ), w * Math.cos( t * box.speed.z * .01 ), box.position.z );

                box.rotation.set( 0, t * box.speed.y, t * box.speed.z );
            }
        }
    }

    render () {
        super.render();
    }
}
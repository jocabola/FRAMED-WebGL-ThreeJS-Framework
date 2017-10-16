let mersenne = require( 'mersenne' );

export default class Random {
    constructor ( seed=0 ) {
        this.seed( seed );
    }

    seed ( seed=0 ) {
        this.seedValue = seed;
        mersenne.seed( seed );
    }

    // returns float [0..1]
    random () {
        let N = 1000;
        return mersenne.rand(N)/(N-1);
    }

    // returns random integer from min to max
    randi( min=0, max=1 ) {
        return Math.floor( this.randf(min,max) );
    }

    // returns random float from min to max
    randf( min=0, max=1 ) {
        return min + ( max - min ) * this.random();
    }
}
// Expose all libraries that you are going to use.
//dat = require( 'dat-gui' );
Stats = require( 'stats-js' );
THREE = require( 'three' );
Detector = require( './lib/Detector.js' );

// Check if running in Desktop mode
var isDesktop = window.isDesktop = window && window.process && window.process.type;
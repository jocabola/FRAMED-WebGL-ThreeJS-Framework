var fs = require('fs');
var fse = require( 'fs-extra' );
var execSync = require('child_process').execSync;
var mkdirp = require( "mkdirp" );

// ----- CONFIG AREA ---------------------------------------

// ASSETS
var CDN_URL = "./";

// SRC FILE TO SCAN
var src_path = 'public/';
var src = src_path + 'index.html';

// DEPLOY ROOT
var deploy_path = 'deploy/';

console.log( "Cleaning up..." );
fse.emptyDirSync( deploy_path + 'assets' );


// ---------- COMPILER -------------------------------------

console.log( "publishing new revision..." )
fse.copySync( src_path, deploy_path );

var string = fs.readFileSync( src, { encoding: 'utf-8' } );

console.log( 'Copying Files to Deploy...' );

var rev = Date.now();

console.log( 'Generating index.html...' );

var ifile = fs.openSync( deploy_path + 'index.html', 'w' );
string = string.replace( 'assets/js/main.js', 'assets/js/main-' + rev + '.js' );
string = string.replace( 'assets/css/styles.css', 'assets/css/styles-' + rev + '.css' );
fs.writeSync( ifile, string );
fs.close( ifile );

console.log( "creating JS rev files..." );
fs.renameSync( deploy_path + 'assets/js/main.js', deploy_path + 'assets/js/main-' + rev + '.js' );

//console.log( "Minifying CSS files [YUI] ..." );

var compressor = require('node-minify');

console.log( "Minifying CSS files ..." );

var minifier = require('minifier');

minifier.on('error', function(err) {
	// handle any potential error
	console.log( err );
})
minifier.minify(deploy_path + 'assets/css/styles.css', { output: deploy_path + 'assets/css/styles-' + rev + '.css' });
fse.removeSync( deploy_path + 'assets/css/styles.css' );

console.log( "Done. Successfully created revision " + rev );
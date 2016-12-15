var deploy_path = './deploy/';

var fs = require( 'fs' );
var execSync = require('child_process').execSync;

// APP settings
var app_version = "0.1.0";

// Add your app icon if you like
//var app_icon_path = 'path to ico file';
var app_icon_path = ''

execSync( __dirname + '/node_modules/.bin/electron-packager ./deploy main --platform=win32 --arch=ia32 --app-version=' + app_version + ' --icon=' + app_icon_path + ' --out tmp --overwrite' );
console.log( "Done" );
process.exit();
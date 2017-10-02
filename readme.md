# FRAMED WebGL + Threejs framework
A boilerplate to easily deploy ThreeJS/WebGL apps for the [FRAMED](https://frm.fm/) device as Windows EXE apps.

It currently uses Node with budo and browserify for easily coding with classes and testing/running it in your browser during production.

~~It is currently written in CoffeeScript and will be soon translated into JavaScript ES6.~~
It uses ECMAScript 6, also known as ECMAScript 2015, in the current version.

To build Windows executable I am using [Electron](http://electron.atom.io/) which makes it super simple to test your app in Desktop mode and helps encapsulating everything using a modern Chromium build which is very close to latest Google Chrome's builds.

This framework is extensible to any Web based apps for the FRAMED device or Windows. You can use Canvas, CSS, WebAudio, or any web technology supported in modern Chromium builds. You can use Electron's built in NodeJS capabilities to extend browser features.

WINE dependency on OS X and Linux when building on non Windows Systems.

[Changelog](changelog.md)

#### Warning!
This is still a very early ALPHA under development and testing in collaboration with FRAMED folks. I will be pushing updates as soon as possible. Use & test freely and at your own risk.

## Instructions of use

**1) Install**

`npm install`

**2) To start testing your app in browser type:**

`npm start`

This should open your browser automatically.

**3) To test desktop app:**

`npm run test`

**4) To package and distribute the Windows EXE:**

`npm run build`

Your app will be saved to a folder named *main-win32-ia32* inside *tmp*. To upload your app at FRAMED you will need to zip *main-win32-ia32* contents (not the folder) and upload the ZIP file.

**5) Setup Your FRAMED App**

Edit package.json file inside public folder.

Edit build.js to add APP icons and amend Electron compiling settings. The App MUST be in win32/ia32 architecture.

## Source Code

The source code of the web app is located at *src* folder, while the *index.html* alongside any other CSS and image files you need are located at *public* folder.

## Other Dependencies / Requirements

Java is required for compiling app.

You will also need to have [Wine](https://www.winehq.org/) and [XQuartz](https://xquartz.macosforge.org) installede if you are on OS X.

Once XQuarz is installed you can install wine via homebrew:

`brew install wine`

## Credits

This framework uses a bunch of libraries and NPM packages alongside [Electron](https://github.com/electron) and [ThreeJS](https://github.com/mrdoob/three.js/).


## License

*MIT licensed*

*Copyright (c) 2016-2017 Eduard Prats Molner, aka Jocabola, jocabola.com*

*Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:*

*The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.*

*THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.*
# FRAMED WebGL + regl framework
A boilerplate to easily deploy regl/WebGL apps for the [FRAMED](https://frm.fm/) device as Windows EXE apps.

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

The source code of the web app is located at [src](./src/) folder, while the [index.html](./public/index.html) alongside any other [CSS](./public/assets/css/styles.css) and image files you need are located at [public](./public/) folder.

You only need to edit [App.js](./src/apps/App.js) to create your own App. This file extends [Core.js](./src/apps/Core.js) that contains the setup of the WebGL Renderer, Scene & Camera.

Define your geometry, materials and elements inside `create` function.

Use the `update` function for animations. You can use [this.timer](./src/utils/Timer.js) to fetch current animation time (starts at 0). Use `getTimeMs()` to get time in Milliseconds or `getTimeS()` to get current time in seconds.

## Other Dependencies / Requirements

Java is required for compiling app.

You will also need to have [Wine](https://www.winehq.org/) and [XQuartz](https://xquartz.macosforge.org) installede if you are on OS X.

Once XQuarz is installed you can install wine via homebrew:

`brew install wine`

## Performance Notes

The platform is quite limiting in terms of performance. The FPS was quite disappointing when having just a single spining cube at full HD resolution. Reducing the WebGL canvas size (downsampling) helps a lot. A single spining cube runs at *30 FPS* with a scale factor of *0.5*, meaning that the real resolution is *540 x 960 pixels*. The built-in example with 500 spinning cubes keeps running at *~30 FPS* at this resoluion although seems to go sometimes below that after running for a while.

The given example is not super fancy though. You can probably obtain better results or use more geometry with some advanced graphics programming work like a *GPGPU* pipeline combined with merged or instanced geometries and so on. The intention of this framework is to be as accessible as possible. I will do some further performance tests using such techniques and document it whenever possible.

## Credits

This framework uses a bunch of libraries and NPM packages alongside [Electron](https://github.com/electron) and [regl](http://regl.party/).


## License

*MIT licensed*

*Copyright (c) 2016-2017 Eduard Prats Molner, aka Jocabola, jocabola.com*

*Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:*

*The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.*

*THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.*
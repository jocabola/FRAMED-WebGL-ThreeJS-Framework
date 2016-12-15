App = require './apps/MyApp.coffee'

#navigator.getUserMedia  = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia

Main = new ->
	initialized = false
	app = null
	stats = null

	init = () ->
		if !initialized
			initialized = true
			
			app = new App document.querySelector( '.container' )
			stats = new Stats()
			stats.domElement.style.position = 'absolute'
			stats.domElement.style.bottom = '0px'
			stats.domElement.style.right = '0px'
			stats.domElement.style.zIndex = '100'
			document.body.appendChild stats.domElement
			animate()

	animate = () ->
		requestAnimationFrame animate
		stats.begin()
		app.update()
		app.render()
		stats.end()
		

	return {
		init: init
	}

#launch
Main.init()
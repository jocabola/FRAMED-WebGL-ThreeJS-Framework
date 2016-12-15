Renderer = require '../gfx/Renderer.coffee'
#glslify = require 'glslify'

class App
	constructor: ( @container ) ->
		@renderer = new Renderer @container
		@scene = @renderer.scene
		@time = 0
		@startTime = Date.now()
		@pausedTime = 0
		@paused = false
		@frameCount = 0

		window.addEventListener 'resize', ( e ) =>
			@resize()
		, false

	playPause: ->
		return @resume() if @paused
		@pause()

	pause: ->
		@pausedTime = Date.now()
		@paused = true

	resume: ->
		@startTime = Date.now() - @time
		@paused = false

	update: () ->
		return if @paused
		
		time = Date.now() - @startTime
		dt = time - @time
		@manualUpdate time, dt

	manualUpdate: ( time, dt ) ->
		@frameCount++
		@time = time
	
	render: ( force=false ) ->
		@renderer.render()

	resize: () ->
		@renderer.resize()
		@resizeHandler()

	resizeHandler: ->
		# override this function in case you need to react to resizing

module.exports = App;
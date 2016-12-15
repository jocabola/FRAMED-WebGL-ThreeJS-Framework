class AV
	constructor: ( @app ) ->
		@frameCount = 0
		@fps = 60
		@df = 1000/@fps
		@rendering = false
		@totalFrames = 0
		@framesRendered = 0
		@renderingVideo = false
		@codec = "png"
		@timeout = -1

		@sys = new AVSYS()

		@canvas = @app.renderer.renderer.domElement

		@ui = el 'div', 'exporter'

		exitExporting = ( e ) =>
			return if !@rendering
			return if e.keyCode != 27
			if @renderingVideo
				if !window.confirm( "Are you sure you want to stop video rendering?" )
					return
			document.body.removeChild @ui
			@rendering = false
			@renderingVideo = false
			@unblockApp()
			window.clearTimeout @timeout


		window.addEventListener 'keydown', exitExporting, false

		sys = @sys
		
		window.AV = @ # expose AV interface globally

	addCommandsToGUI: ( gui ) ->
		controls =
			renderStill: =>
				@renderStill()
			renderVideo: =>
				@renderVideo()


		f = gui.addFolder "Rendering"
		f.add( controls, "renderStill" ).name( "Render Still" )
		f.add( controls, "renderVideo" ).name( "Render Video" )
		f.open()

	renderStill: ->
		return if @rendering

		@rendering = true
		@app.resume() # avoid render blocking
		@app.resizeHandler() # force updating stuff (just in case)

		if @app.gui
			@app.gui.domElement.style.display = 'none'
		@app.counter.style.display = 'none'

		@ui.innerHTML = "<h1>Export Still Frame</h1>"

		@ui.innerHTML += "<p>Time (ms): <input id='time' style='width:80px;' value='#{@app.time}'/></p>"
		@ui.innerHTML += "<p>Picture Size (px): <input id='iwidth' style='width:40px;' value='#{@canvas.width}'/> x <input id='iheight' style='width:40px;' value='#{@canvas.height}'/></p>"
		@ui.innerHTML += "<p><input type='button' class='btn' value='Save' /></p>"

		document.body.appendChild @ui

		frameRendered = =>
			@rendering = false
			@unblockApp()
			document.body.style.cursor = 'default'

		updateTime = ( e ) =>
			@app.manualUpdate parseInt( @ui.querySelector( '#time' ).value ), @df
			@app.render true

		doExport = =>
			@app.renderer.resize parseInt( @ui.querySelector( '#iwidth' ).value ), parseInt( @ui.querySelector( '#iheight' ).value )
			@app.resizeHandler()
			@app.manualUpdate parseInt( @ui.querySelector( '#time' ).value ), @df
			@app.render true
			@sys.renderStill @canvas, frameRendered

		exportPicture = ( e ) =>
			m = 16777216
			pm = parseInt( @ui.querySelector( '#iwidth' ).value ) * parseInt( @ui.querySelector( '#iheight' ).value )
			if pm >= m
				return if !window.confirm( "Picture size is equal or greater than #{m} pixels. This might cause picture stretching or incorrect cropping. Contineu Anyway?" )
			document.body.removeChild @ui
			document.body.style.cursor = 'wait'
			@timeout = window.setTimeout doExport, 100

		@ui.querySelector( '.btn' ).addEventListener 'click', exportPicture, false
		@ui.querySelector( '#time' ).addEventListener 'change', updateTime, false

	renderVideo: ->
		return if @rendering

		@rendering = true
		@renderingVideo = true
		@app.resume() # avoid render blocking
		@app.resizeHandler() # force updating stuff (just in case)

		if @app.gui
			@app.gui.domElement.style.display = 'none'
		@app.counter.style.display = 'none'

		@ui.innerHTML = "<h1>Export Video</h1>"

		@ui.innerHTML += "<p>Start Time (s): <input id='time' style='width:80px;' value='0'/></p>"
		@ui.innerHTML += "<p>Duration (s): <input id='duration' style='width:80px;' value='10'/></p>"
		@ui.innerHTML += "<p>Video Resolution: <select id='vsize' name='vsize' style='width:240px;'>
			<option value='1'>Preview: 480x260</option>
			<option value='2' selected>720p: 1280x720</option>
			<option value='3'>1080p: 1920x1080</option>
			<option value='4'>4K: 3840x2160</option>
		<select/></p>"
		@ui.innerHTML += "<p>Picture Size (px): <input id='iwidth' style='width:40px;' value='1280'/> x <input id='iheight' style='width:40px;' value='720'/></p>"
		@ui.innerHTML += "<p>FPS: <input id='vfps' style='width:40px;' value='60'/> <span class='small'>60 recommended. Other standard values 30, 29, 25</span></p>"
		###@ui.innerHTML += "<p>Video Codec: <select id='vcodec' name='vcodec' style='width:240px;'>
			<option value='1' selected>Uncompressed</option>
			<option value='2'>PNG Lossless</option>
			<option value='3'>h.264</option>
		<select/></p>"###
		@ui.innerHTML += "<p><input type='button' class='btn' value='Export' /></p>"

		document.body.appendChild @ui

		updateTime = ( e ) =>
			@app.manualUpdate parseFloat( @ui.querySelector( '#time' ).value ) * 1000, @df
			@app.render true

		updateSize = ( e ) =>
			w = @ui.querySelector( '#iwidth' )
			h = @ui.querySelector( '#iheight' )
			if @ui.querySelector( '#vsize' ).value == '1'
				w.value = 480
				h.value = 260
			else if @ui.querySelector( '#vsize' ).value == '2'
				w.value = 1280
				h.value = 720
			else if @ui.querySelector( '#vsize' ).value == '3'
				w.value = 1920
				h.value = 1080
			else if @ui.querySelector( '#vsize' ).value == '4'
				w.value = 3840
				h.value = 2160

		doExport = =>
			@app.renderer.resize parseInt( @ui.querySelector( '#iwidth' ).value ), parseInt( @ui.querySelector( '#iheight' ).value )

			w = @canvas.width
			h = @canvas.height
			r = w / h

			if w > window.innerWidth
				w = window.innerWidth
				h = w / r
			if h > window.innerHeight
				h = window.innerHeight
				w = h * r

			@canvas.style.left = "#{(window.innerWidth-w)/2}px"
			@canvas.style.top = "#{(window.innerHeight-h)/2}px"
			@canvas.style.width = "#{w}px"
			@canvas.style.height = "#{h}px"

			@app.resizeHandler()
			@app.manualUpdate parseInt( @ui.querySelector( '#time' ).value ), @df
			@app.render true
			#@sys.renderStill @canvas, frameRendered

			@fps = Math.max 15, parseInt( @ui.querySelector( '#vfps' ).value )
			@df = 1000/@fps
			@startTime = parseFloat( @ui.querySelector( '#time' ).value ) * 1000
			@framesRendered = 0
			@totalFrames = Math.ceil( parseFloat( @ui.querySelector( '#duration' ).value ) * @fps )
			@renderingVideo = true
			@videoEncoded = false
			@videoID = Date.now()

			###codec = @ui.querySelector( '#vcodec' ).value

			
			if codec == "2"
				@codec = "png"
			else if codec == "1"
				@codec = "v210"
			else
				@codec = "libx264"###

			@codec = "png"

			@ui.innerHTML = "<h1>Exporting Video</h1>"
			@ui.innerHTML += "<div class='progress-base'><div class='progress'></div></div>"
			@ui.innerHTML += "<p class='progress-info'>Rendered Frames: #{@framesRendered}/#{@totalFrames}</div>"
			document.body.appendChild @ui
			document.body.style.cursor = 'default'

			@renderVideoFrame()

		exportVideo = ( e ) =>
			m = 16777216
			pm = parseInt( @ui.querySelector( '#iwidth' ).value ) * parseInt( @ui.querySelector( '#iheight' ).value )
			if pm >= m
				return if !window.confirm( "Picture size is equal or greater than #{m} pixels. This might cause picture stretching or incorrect cropping. Contineu Anyway?" )
			document.body.removeChild @ui
			document.body.style.cursor = 'wait'
			@timeout = window.setTimeout doExport, 100

		@ui.querySelector( '#time' ).addEventListener 'change', updateTime, false
		@ui.querySelector( '#vsize' ).addEventListener 'change', updateSize, false
		updateTime null
		@ui.querySelector( '.btn' ).addEventListener 'click', exportVideo, false

	unblockApp: ->
		if @app.gui
			@app.gui.domElement.style.display = 'block'
		@app.counter.style.display = 'block'
		@app.renderer.resize window.innerWidth, window.innerHeight
		@canvas.style.width = '100%'
		@canvas.style.height = '100%'
		@canvas.style.top = '0px'
		@canvas.style.left = '0px'
		@app.resizeHandler()

	renderVideoFrame: ->
		return if !@rendering
		if @framesRendered > @totalFrames
			return @encodeVideo()
		@ui.querySelector( '.progress-info' ).textContent = "Rendered Frames: #{@framesRendered}/#{@totalFrames}"
		@ui.querySelector( '.progress' ).style.width = "#{90*@framesRendered/@totalFrames}%"
		
		frameRendered = =>
			@framesRendered++
			@renderVideoFrame()

		@app.manualUpdate @startTime + @df * @framesRendered, @df
		@app.render true
		
		@sys.renderVideoFrame @canvas, @videoID, @framesRendered, frameRendered

	encodeVideo: ->
		document.body.style.cursor = 'wait'
		progressCallback = ( progress ) =>
			w = 90 + 10 * (progress.frames/@totalFrames)
			@ui.querySelector( '.progress-info' ).textContent = "Encoding..."
			@ui.querySelector( '.progress' ).style.width = "#{w}%"

		onComplete = =>
			@rendering = false
			@renderingVideo = false
			@unblockApp()
			document.body.removeChild @ui
			document.body.style.cursor = 'default'

		@sys.encodeVideo @videoID, @fps, @codec, @canvas.width, @canvas.height, onComplete, progressCallback

module.exports = AV;
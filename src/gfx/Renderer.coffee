class Renderer
	constructor: ( container ) ->
		# Defining FRAMED 2.0 HD resolution and settings
		@width = 1080
		@height = 1920
		@ratio = @width / @height
		@oversampling = 1 # we can use oversampling to increase performance

		w = @width
		h = @height

		@renderer = new THREE.WebGLRenderer { antialias: true, alpha: true, preserveDrawingBuffer: true }
		@renderer.setSize w, h
		container.appendChild @renderer.domElement

		#@camera = new THREE.PerspectiveCamera 45, w/h, 1, 10000
		@camera = new THREE.OrthographicCamera -w/2, w/2, h/2, -h/2, 1, 10000		# Defining FRAMED 2.0 HD resolution and settings
		@scene = new THREE.Scene()
		@scene.add @camera

		@resize()

	render: () ->
		# render loop: modify if you need custom rendering & compositing
		@renderer.render @scene, @camera

	resize: () ->
		w = @width
		h = @height

		ww = window.innerWidth
		wh = window.innerHeight

		#make sure oversampling factor is not smaller than 1
		@oversampling = Math.max 1, @oversampling
		factor = 1 / @oversampling

		if @oversampling > 1
			w *= factor
			h *= factor

		# set renderer viuewport size
		@renderer.setSize w, h
		
		# cover screen with canvas
		vw = ww
		vh = ww / @ratio
		if vh > wh
			vh = wh
			vw = vh * @ratio
		
		@renderer.domElement.style.width = "#{vw}px"
		@renderer.domElement.style.height = "#{vh}px"
			

		# resize for perspective camera
		#@camera.aspect = w/h
		
		# resize for orthographic camera
		@camera.left = -w/2
		@camera.right = w/2
		@camera.top = h/2
		@camera.bottom = -h/2

		# update projection matrix
		@camera.updateProjectionMatrix()

module.exports = Renderer;
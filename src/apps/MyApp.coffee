App = require './App.coffee'

class MyApp extends App
	constructor: ( container ) ->
		super container

		@settings =
			rows: 20
			rps: 50
			apply: () =>
				@reset()
				@renderer.render()

		@scene.add new THREE.AmbientLight( 0x333333 )
		@scene.add new THREE.PointLight( 0xffffff, .7 )

		@cubes = new THREE.Object3D()
		@renderer.scene.add @cubes

		@reset()

		onKeyDown = ( event ) =>
			#console.log event.keyCode

			switch event.keyCode
				when 49 # 1
					@settings.rows = 20
					@reset()
				when 50 # 2
					@settings.rows = 30
					@reset()
				when 51 # 3
					@settings.rows = 40
					@reset()
				when 52 # 4
					@settings.rows = 50
					@reset()
				when 53 # 5
					@renderer.oversampling = 1
					@resize()
				when 54 # 6
					@renderer.oversampling = 2
					@resize()
				when 55 # 7
					@renderer.oversampling = 3
					@resize()
				when 56 # 8
					@renderer.oversampling = 4
					@resize()
				when 57 # 9
					@renderer.oversampling = 6
					@resize()

		window.addEventListener 'keydown', onKeyDown, false
		
	manualUpdate: ( time, dt ) ->
		super time, dt
		
		# time based animations
		TP = Math.PI * 2

		t = @settings.rps * 1000

		for k,c of @cubes.children
			c.rotation.y =  ( TP + k * .01 ) * time / t
			c.rotation.x = -( TP + k * .01 ) * time / t

	resizeHandler: ->
		super
		@reset()

	reset: ->
		# remove existing cubes
		@cubes.remove @cubes.children[0] while @cubes.children.length

		w = @renderer.renderer.getSize().width
		h = @renderer.renderer.getSize().height
		s = h / @settings.rows
		hs = s/2
		cs = s * .6

		console.log w, h, s

		@material = new THREE.MeshPhongMaterial( { color: 0x333333 } )

		for j in [-h/2+hs..h/2-hs] by s
			for i in [-w/2+hs..w/2-hs] by s
				mat = @material.clone()
				mat.color.setRGB ( i + w/2 )/w, 0, ( j + h/2 )/h
				mesh = new THREE.Mesh new THREE.BoxGeometry( cs, cs, cs ), mat
				mesh.position.z = -100
				mesh.position.x = i
				mesh.position.y = -j
				@cubes.add mesh

		@cubes.position.set -( i - w/2-hs ) * .5, ( j - h/2-hs ) * .5, 0

		console.log "#{@cubes.children.length} cubes available"

		@startTime = Date.now()

module.exports = MyApp
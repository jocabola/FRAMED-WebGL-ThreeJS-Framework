export default class GLParams {
    constructor ( gl ) {
        this.gl = gl;

        let glExtensionDebugRendererInfo = gl.getExtension( 'WEBGL_debug_renderer_info' );
		let glExtensionTextureFloat = gl.getExtension( 'OES_texture_float' );
		let glExtensionTextureHalfFloat = gl.getExtension( 'OES_texture_half_float' );

		this.maxTextureSize = gl.getParameter( gl.MAX_TEXTURE_SIZE );
		this.maxCubeTextureSize = gl.getParameter( gl.MAX_CUBE_MAP_TEXTURE_SIZE );
		this.maxTextureUnits = gl.getParameter( gl.MAX_TEXTURE_IMAGE_UNITS );
		this.maxViewportSize = gl.getParameter( gl.MAX_VIEWPORT_DIMS );
		this.pointSizeMin = gl.getParameter( gl.ALIASED_POINT_SIZE_RANGE )[0];
		this.pointSizeMax = gl.getParameter( gl.ALIASED_POINT_SIZE_RANGE )[1];
		this.maxVertexImageUnits = gl.getParameter( gl.MAX_VERTEX_TEXTURE_IMAGE_UNITS );
		this.vendor = glExtensionDebugRendererInfo && gl.getParameter( glExtensionDebugRendererInfo.UNMASKED_RENDERER_WEBGL ) ? gl.getParameter( glExtensionDebugRendererInfo.UNMASKED_VENDOR_WEBGL ) : "unknown";

		// render target float formats (RGBA)
		this.halfFloatRenderTarget = ( glExtensionTextureHalfFloat && this.checkRenderTargetSupport( gl.RGBA, glExtensionTextureHalfFloat.HALF_FLOAT_OES ) );
		this.fullFloatRenderTarget = ( glExtensionTextureFloat && this.checkRenderTargetSupport( gl.RGBA, gl.FLOAT ) );

		if ( this.halfFloatRenderTarget == null ) this.halfFloatRenderTarget = false;
		if ( this.fullFloatRenderTarget == null ) this.fullFloatRenderTarget = false;
    }

    checkRenderTargetSupport (format, type) {
        // create temporary frame buffer and texture

		let framebuffer = this.gl.createFramebuffer();
		let texture = this.gl.createTexture();

		this.gl.bindTexture( this.gl.TEXTURE_2D, texture );
		this.gl.texImage2D( this.gl.TEXTURE_2D, 0, format, 2, 2, 0, format, type, null );

		this.gl.bindFramebuffer( this.gl.FRAMEBUFFER, framebuffer );
		this.gl.framebufferTexture2D( this.gl.FRAMEBUFFER, this.gl.COLOR_ATTACHMENT0, this.gl.TEXTURE_2D, texture, 0 );

		// check frame buffer status
		let status = this.gl.checkFramebufferStatus( this.gl.FRAMEBUFFER );

		// clean up
		this.gl.bindFramebuffer( this.gl.FRAMEBUFFER, null );
		this.gl.bindTexture( this.gl.TEXTURE_2D, null );

		return status === this.gl.FRAMEBUFFER_COMPLETE;
    }
}
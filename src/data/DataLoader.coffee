class DataLoader
	load: ( url, callback=null, opts={} ) ->
		console.log "load #{url}"
		r = new XMLHttpRequest()
		r.open "GET", "#{url}", true
		
		if opts.responseType
			r.responseType = opts.responseType

		###r.onreadystatechange = () =>
			if r.readyState != 4 || r.status != 200
				return
			if ( callback != null )
		  		callback( r.responseText )###

		r.onload = () =>
			if ( callback != null )
		  		callback r

		r.send()

module.exports = DataLoader;
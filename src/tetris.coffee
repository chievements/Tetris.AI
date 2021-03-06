# TODO testing! there is probably something wrong with it
solveFlooredRatio = (w, h, w2, h2) ->
	if (w / h < w2 / h2) # Too much height
		w2 = w2 - (w2 % gcd(w, h))
		h2 = (h * w2) / w
	else                 # Too much width
		h2 = h2 - (h2 % gcd(h, w))
		w2 = (w * h2) / h
	[w2, h2]

getImage = (image) ->
	cache.images.cache[image] or (
		cache.images.cache[image] = new Image()
		cache.images.cache[image].src = cache.images[if settings.locale then 'offline' else 'links'][image]
		cache.images.cache[image]
	)

class tetris
	constructor: (element) ->
		init()

		element ?= "game"
		@c = document.getElementById(element).getContext("2d")

		@state = new state()

		if settings.debug
			@cache = cache

		@drawer     = new draw(0, 0, @c.canvas.width, @c.canvas.height, @c, @state)
		@keyHandler = new keyHandler()
		@doDraw = false

		@state.updateDisplay = () =>
			if @doDraw == false
				window.requestAnimationFrame(() =>
					@doDraw = false
					@drawer.draw()
				)
				@doDraw = true
			return

		@keyHandler.registerKeyDown(37, (e) =>
			@state.moveLeft()

			e.preventDefault()
			return false
		)
		@keyHandler.registerKeyDown(38, (e) =>
			@state.rotateRight()

			e.preventDefault()
			return false
		)
		@keyHandler.registerKeyDown(39, (e) =>
			@state.moveRight()

			e.preventDefault()
			return false
		)
		@keyHandler.registerKeyDown(40, (e) =>
			@state.moveDown()

			e.preventDefault()
			return false
		)
		@keyHandler.registerKeyDown(32, (e) =>
			@state.doDrop()
			clearInterval(int)

			e.preventDefault()
			return false
		)
		@keyHandler.registerKeyDown(16, (e) =>
			@state.storeBlock()

			e.preventDefault()
			return false
		)
		@keyHandler.registerKeyDown(17, (e) =>
			@state.rotateLeft()

			e.preventDefault()
			return false
		)

		@draw()

		#getImage('clown').onload = () =>
			#@draw()

	draw: () ->
		@drawer.draw()
		return


#foo = ["lets", "test", "something", "out"]
#console.debug "'" + shuffle(foo).join(" ") + "'"
#console.debug foo

game = null
int = null
intval = 1010
cpu_mode = false

$(document)['ready'] () ->
	game = new tetris()
	$('#human').attr("disabled",true)

	$('#human').click ->
		game.keyHandler.registerEventHandlers()
		intval = 1010
		cpu_mode = false
		$('#human').attr("disabled",true)
		$('#cpu').attr("disabled",false)
			

	$('#cpu').click ->
		int = setTimeout(ai, 10)
		game.keyHandler.unregisterEventHandlers()
		cpu_mode = true
		$('#human').attr("disabled",false)
		$('#cpu').attr("disabled",true)


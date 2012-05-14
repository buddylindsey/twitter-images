express = require('express')
app = module.exports = express.createServer()
io = require('socket.io').listen(app)
db = require('./db')()
mongoose = require('mongoose')

app.configure () ->
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.static("#{__dirname}/public")
  app.use require('connect-assets')()
  return

app.get '/', (req, res) ->
  res.render('index', { title: 'Latest Images from Twitter...' })
  return

# Sets up the main application to continuasly give back iamges
io.sockets.on 'connection', (socket) ->
  processImages = true
  latest_image = ''
  console.log('is connected')

  # Changes the active state of the images going back and forth
  socket.on 'state', (data) ->
    processImages = data.state
    console.log('state')
    return

  set_last_image = (data) ->
    latest_image = data
    return

  send_image = (data) ->
    socket.emit 'images', data

  run_it = () ->
    db.nextImages latest_image, send_image, set_last_image
    return

  first_images = () ->
    db.firstImages send_image, set_last_image
    return

  first_images()

  interval = setInterval run_it, 30000

  socket.on 'disconnect', () ->
    clearInterval(interval)
    return

  return

app.listen 3000
console.log "Express server running"

$(document).ready () ->
  processImages = true

  socket = io.connect(document.uri)
  
  socket.on 'images', (data) ->
    $('#images').prepend "<div class='separator'>Updates Above...</div>"
    $('#images').prepend "<img src='#{img}' /><br />" for img in data
    return

  $("#stop").click () ->
    if(processImages)
      socket.emit 'state', {state: false}
      processImages = false
    else
      socket.emit 'state', {state: true}
      processImages = true
    return
  

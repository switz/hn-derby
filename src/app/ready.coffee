app = require '../app'
config = require './config'
{ view, ready } = require './index'

#############
## Ready
#############

ready (model) ->
  user = model.at '_user'

  @upvote = (e, el, next) ->
    post = model.at(el)
    userId = user.get('id')
    postId = post.get('id')

    model.subscribe model.query('users').upvoted(userId, postId), (err, upvoted) ->
      if upvoted
        alert('you already upvoted this')
      else
        post.incr 'score'
        user.at("upvotes.#{postId}").set true
        $(el).css('opacity', 0)

  # Exported functions are exposed as a global in the browser with the same
  # name as the module that includes Derby. They can also be bound to DOM
  # events using the "x-bind" attribute in a template.
  @stop = ->
    # Any path name that starts with an underscore is private to the current
    # client. Nothing set under a private path is synced back to the server.
    model.set '_stopped', true

  do @start = ->
    model.set '_stopped', false

  model.set '_showReconnect', true
  @connect = ->
    # Hide the reconnect link for a second after clicking it
    model.set '_showReconnect', false
    setTimeout (-> model.set '_showReconnect', true), 1000
    model.socket.socket.connect()

  @reload = -> window.location.reload()

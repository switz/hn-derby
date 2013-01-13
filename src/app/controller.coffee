derby = require 'derby'
{ view } = require './index'
{ render } = require './render'

{ encodeMongoId, decodeMongoId } = require '../lib/utils'

controller = {}

# /
controller.home = (page, model) ->
  model.subscribe 'news.posts', (err, posts) ->
    console.log err if err
    model.refList '_list', 'news.posts', 'news.posts.ids'
    render page, 'home'

# /submit
controller.submit = (page, model, {body, query}) ->
  if body and body.story
    title = body.story.title
    url = body.story.url

    model.subscribe 'news.posts', (err, posts) ->
      if err then console.log err
      console.log "Adding #{title}"
      id = posts.add {title, url}

      # Push id to array of news.posts.ids for refList
      posts.push 'ids', id

      # Redirect to post page
      view.app.history.push "/post/#{id}"

      render page, 'submit'
  else
    render page, 'submit'

# /post/:id
controller.post = (page, model, {id}) ->
  model.subscribe "news.posts.#{id}", (err, post) ->
    model.ref '_post', post

    render page, 'post'


module.exports = controller

# import ready callback
require './ready'

# import view functions
require './viewFunctions'

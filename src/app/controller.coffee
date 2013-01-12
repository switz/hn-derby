derby = require 'derby'
render = require './render'

controller = {}

# /
controller.home = (page, model) ->
  model.subscribe 'news.posts', (err, posts) ->
    console.log err if err
    model.refList '_list', 'news.posts', 'news.posts.ids'
    render page, 'home'

# /submit
controller.submit = (page, model, {body, query}) ->
  args = JSON.stringify {body, query}, null, '  '

  if body and body.story
    title = body.story.title
    url = body.story.url

    model.subscribe 'news.posts', (err, posts) ->
      if err then console.log err
      console.log "Adding #{title}"
      id = posts.add {title, url}

      # Push id to array of news.posts.ids for refList
      posts.push 'ids', id

  render page, 'submit', {args}

module.exports = controller

# import ready callback
require './ready'

# import view functions
require './viewFunctions'

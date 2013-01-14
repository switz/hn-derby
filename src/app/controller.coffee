derby = require 'derby'
{ view } = require './index'
{ render } = require './render'
{ validateUrl } = require '../lib/utils'

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

    unless title and validateUrl url
      model.set '_newPost',
        error: true
      return render page, 'submit'

    model.subscribe 'news.posts', (err, posts) ->
      if err then console.log err

      score = 0

      id = posts.add {title, url, score}
      # Push id to array of news.posts.ids for refList
      posts.push 'ids', id
      # Redirect to post page
      view.app.history.push "/post/#{id}"

      model.del m for m in ['_newTitle', '_newUrl', '_newPost']

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

{ get } = app = require './index'
controller = require './controller'

## ROUTES ##

get '/', controller.home

['get', 'post', 'put', 'del'].forEach (method) ->
  app[method] '/submit', controller.submit

get '/post/:id', controller.post

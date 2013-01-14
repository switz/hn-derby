http = require 'http'
path = require 'path'
express = require 'express'
derby = require 'derby'
racer = require 'racer'
auth = require 'derby-auth'
MongoStore = require('connect-mongo')(express)
app = require '../app'
serverError = require './serverError'
io = racer.io

## SERVER CONFIGURATION ##

expressApp = express()
server = module.exports = http.createServer expressApp
module.exports.expressApp = expressApp

derby.use require('racer-db-mongo')

unless process.env.NODE_ENV is 'production'
  racer.use racer.logPlugin
  derby.use derby.logPlugin

store = module.exports.pvStore = derby.createStore
  listen: server
  db:
    type: 'Mongo'
    uri: process.env.HN_URI
    safe: true

ONE_YEAR = 1000 * 60 * 60 * 24 * 365
root = path.dirname path.dirname __dirname
publicPath = path.join root, 'public'

# Authentication setup
strategies =
  github:
    strategy: require("passport-github").Strategy
    conf:
      clientID: process.env.GITHUB_CLIENT_KEY
      clientSecret: process.env.GITHUB_CLIENT_SECRET

options =
  domain: process.env.BASE_URL || 'http://localhost:3000'

mongoStore = new MongoStore { url: process.env.HN_URI }, ->
  expressApp
    .use(express.favicon())
    # Gzip static files and serve from memory
    .use(express.static publicPath)
    # Gzip dynamically rendered content
    .use(express.compress())

    # Uncomment to add form data parsing support
    .use(express.bodyParser())
    .use(express.methodOverride())

    # Uncomment and supply secret to add Derby session handling
    # Derby session middleware creates req.session and socket.io sessions
    .use(express.cookieParser())
    .use(store.sessionMiddleware
      secret: process.env.SESSION_SECRET || 'session secret'
      cookie: {maxAge: ONE_YEAR}
      store: mongoStore
    )

    # Adds req.getModel method
    .use(store.modelMiddleware())
    .use((req, res, next) ->
      model = req.getModel()

      model.fetch "users.#{model.session.userId}", (err, user) ->
        if err then console.log err

        model.ref '_user', user
        next()
    )
    # Adds auth
    .use(auth(store, strategies, options))
    # Creates an express middleware from the app's routes
    .use(app.router())
    .use(expressApp.router)
    .use(serverError root)

  routes = require './routes'

  queries = require './queries'

# Infinite stack trace
Error.stackTraceLimit = Infinity

io.configure 'production', ->
  io.set "transports", ["websocket", "xhr-polling", "jsonp-polling", "htmlfile"]

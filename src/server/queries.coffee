store = require('./index').pvStore

store.accessControl = false

store.readPathAccess 'conf.*', () -> #captures, next) ->
  next = arguments[arguments.length-1]
  next(true)

store.readPathAccess 'news.*', () -> #captures, next) ->
  next = arguments[arguments.length-1]
  next(true)

## Query Motifs

store.query.expose 'users', 'upvoted', (userId, postId) ->
  @where('id').equals(userId)
    .where('upvotes').equals(postId)

## Give query access

giveQueryAccess = (col, fn) ->
  store.queryAccess col, fn, (methodArgs) ->
    accept = arguments[arguments.length - 1]
    accept true # for now

obj =
  users: ['upvoted']

for col of obj
  obj[col].map (fn) -> giveQueryAccess col, fn

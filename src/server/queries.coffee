store = require('./index').pvStore

store.accessControl = false

store.readPathAccess 'conf.*', () -> #captures, next) ->
  next = arguments[arguments.length-1]
  next(true)

store.readPathAccess 'news.*', () -> #captures, next) ->
  next = arguments[arguments.length-1]
  next(true)

## Query Motifs

store.query.expose 'collection', 'getYear', (year) ->
  @where('year').equals year

## Give query access

giveQueryAccess = (col, fn) ->
  store.queryAccess col, fn, (methodArgs) ->
    accept = arguments[arguments.length - 1]
    accept true # for now

obj =
  collection: ['getYear']

for col of obj
  obj[col].map (fn) -> giveQueryAccess col, fn

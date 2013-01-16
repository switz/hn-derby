{ view } = require './index'
{ validateUrl } = require '../lib/utils'

# View Functions
view.fn 'validateUrl', validateUrl
view.fn 'or', ->
  for arg of arguments
    return true if arg
  false
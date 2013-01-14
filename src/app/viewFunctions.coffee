{ view } = require './index'
{ validateUrl } = require '../lib/utils'

# View Functions
view.fn 'example', (out) -> out
view.fn 'validateUrl', validateUrl

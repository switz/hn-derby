{ view } = require './index'
{ validateUrl } = require '../lib/utils'

# View Functions
view.fn 'validateUrl', validateUrl

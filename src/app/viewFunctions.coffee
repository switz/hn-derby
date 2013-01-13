{ view } = require './index'

{ encodeMongoId, decodeMongoId } = require '../lib/utils'

# View Functions
view.fn 'example', (out) -> out
view.fn 'encodeMongoId', encodeMongoId
view.fn 'decodeMongoId', decodeMongoId
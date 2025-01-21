-- Register extra lze handlers
require('lze').register_handlers(require('lze.x'))
require('lze').register_handlers(require('nixCatsUtils.lzUtils').for_cat)

require('config.opts&keys')
require('config.indent')

require('config.plugins')

require('config.lsp')

require('config.format')

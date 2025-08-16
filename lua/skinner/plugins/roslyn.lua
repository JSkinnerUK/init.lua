-- Required while not available through mason
-- https://github.com/seblyng/roslyn.nvim
-- https://github.com/seblyng/roslyn.nvim

vim.pack.add({{ src = "https://github.com/seblyng/roslyn.nvim" }})
require('roslyn').setup {
	args = {}
}

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-s>", ui.toggle_quick_menu)

vim.keymap.set('n', '<C-h>', function()
    if vim.v.count == 0 then
        require('harpoon.ui').nav_next()
    else
        require('harpoon.ui').nav_file(vim.v.count1)
    end
end, { silent = true })

vim.keymap.set('n', '<C-j>', function()
    require('harpoon.ui').nav_prev()
end, { silent = true })

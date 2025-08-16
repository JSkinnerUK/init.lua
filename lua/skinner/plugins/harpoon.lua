vim.pack.add({"https://github.com/nvim-lua/plenary.nvim.git"})
vim.pack.add({{src="https://github.com/ThePrimeagen/harpoon.git", version="harpoon2"}})

local harpoon = require("harpoon")
harpoon.setup()

vim.keymap.set("n", "<leader>A", function() harpoon:list():prepend() end)
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-s>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<C-n>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-e>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-i>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-o>", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<leader><C-n>", function() harpoon:list():replace_at(1) end)
vim.keymap.set("n", "<leader><C-e>", function() harpoon:list():replace_at(2) end)
vim.keymap.set("n", "<leader><C-i>", function() harpoon:list():replace_at(3) end)
vim.keymap.set("n", "<leader><C-o>", function() harpoon:list():replace_at(4) end)

-- Rework the below if wanting to cycle through files
--vim.keymap.set('n', '<C-h>', function()
--    if vim.v.count == 0 then
--        require('harpoon.ui').nav_next()
--    else
--        require('harpoon.ui').nav_file(vim.v.count1)
--    end
--end, { silent = true })
--
--vim.keymap.set('n', '<C-j>', function()
--    require('harpoon.ui').nav_prev()
--end, { silent = true })

local home = vim.fn.expand("$HOME")
require("chatgpt").setup({
    api_key_cmd = "gpg --decrypt " .. home .. "/secrets/secret.gpg"
})

vim.keymap.set("n", "<leader>ch", ':lua vim.cmd(":ChatGPT")<CR>',
  {silent = true, noremap = true}
)

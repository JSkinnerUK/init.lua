local lsp_installer_ensure_installed = { 
    -- LSP
    "omnisharp_mono",
    "lua_ls",
    "tsserver",
}

require('mason-lspconfig').setup({
  ensure_installed = lsp_installer_ensure_installed,
})
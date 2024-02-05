-- LOOK IN CURRENT DIRECTORY FOR csproj FILE using glob
-- IF NO FILE IN CURRENT DIRECTORY, LOOK IN PARENT DIRECTORY recursively
local function find_closest_csproj(directory)
	-- print("currentFileDirectory: " .. directory)
	local csproj = vim.fn.glob(directory .. "/*.csproj", true, false)
	if csproj == "" then
		csproj = vim.fn.glob(directory .. "/*.vbproj", true, false)
	end
	if csproj == "" then
		-- IF NO FILE IN CURRENT DIRECTORY, LOOK IN PARENT DIRECTORY recursively
		local parent_directory = vim.fn.fnamemodify(directory, ":h")
		if parent_directory == directory then
			return nil
		end
		return find_closest_csproj(parent_directory)
	-- elseif there are multiple csproj files, then return the first one
	elseif string.find(csproj, "\n") ~= nil then
		local first_csproj = string.sub(csproj, 0, string.find(csproj, "\n") - 1)
		print("Found multiple csproj files, using: " .. first_csproj)
		return first_csproj
	else
		return csproj
	end
end


-- CHECK CSPROJ FILE TO SEE IF ITS .NET CORE OR .NET FRAMEWORK
local function getFrameworkType()
	local currentFileDirectory = vim.fn.expand("%:p:h")
	-- print("currentFileDirectory file: " .. currentFileDirectory)
	local csproj = find_closest_csproj(currentFileDirectory)
	-- print("csproj file: " .. csproj)
	if csproj == nil then
		return false
	end
	local f = io.open(csproj, "rb")
	local content = f:read("*all")
	f:close()
	-- return string.find(content, "<TargetFramework>netcoreapp") ~= nil
	local frameworkType = ""
	-- IF FILE CONTAINS <TargetFrameworkVersion> THEN IT'S .NET FRAMEWORK
	if string.find(content, "<TargetFrameworkVersion>") ~= nil then
		frameworkType = "netframework"
	-- IF FILE CONTAINS <TargetFramework>net48 THEN IT'S .NET FRAMEWORK
	elseif string.find(content, "<TargetFramework>net48") ~= nil then
		frameworkType = "netframework"
	-- ELSE IT'S .NET CORE
	else
		frameworkType = "netcore"
	end
	return frameworkType
end

-- CREATE AUTOCMD FOR CSHARP FILES
vim.api.nvim_create_autocmd("FileType",{
	-- pattern = 'cs',
	pattern = { 'cs', 'cshtml', 'vb' },
	callback = function()
		-- print("FileType: cs, cshtml, vb")
		if vim.g.dotnetlsp then
			-- print("dotnetlsp is already set: " .. vim.g.dotnetlsp)
			return
		end
		-- CHECK THE CSPROJ OR SOMETHING ELSE TO CONFIRM IT'S .NET FRAMEWORK OR .NET CORE PROJECT
		local frameworkType = getFrameworkType()
		if frameworkType == "netframework" then
			print("Found a .NET Framework project, starting .NET Framework OmniSharp")
			require'lspconfig'.omnisharp_mono.setup {
				organize_imports_on_format = true,
				on_attach = function (client, bufnr)

					--- Guard against servers without the signatureHelper capability
					if client.server_capabilities.signatureHelpProvider then
						require('lsp-overloads').setup(client, { })

						-- ...
						-- keymaps = {
						-- 		next_signature = "<C-j>",
						-- 		previous_signature = "<C-k>",
						-- 		next_parameter = "<C-l>",
						-- 		previous_parameter = "<C-h>",
						-- 		close_signature = "<A-s>"
						-- 	},
						-- ...


					end

					-- WORKAROUND INVALID CHAR GROUP ISSUE WITH OMNISHARP
					-- FROM: https://github.com/OmniSharp/omnisharp-roslyn/issues/2483#issuecomment-1515504374
					-- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483#issuecomment-1492605642

					-- COMMENTED IT OUT ON 14 SEP 2023, BECAUSE IT SEEMS TO BE FIXED IN THE LATEST VERSION OF OMNISHARP
					-- COMMENTED IT OUT ON 14 SEP 2023, BECAUSE IT SEEMS TO BE FIXED IN THE LATEST VERSION OF OMNISHARP
					-- COMMENTED IT OUT ON 14 SEP 2023, BECAUSE IT SEEMS TO BE FIXED IN THE LATEST VERSION OF OMNISHARP
					-- local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
					-- for i, v in ipairs(tokenModifiers) do
					-- 	local tmp = string.gsub(v, ' ', '_')
					-- 	tokenModifiers[i] = string.gsub(tmp, '-_', '')
					-- end
					-- local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
					-- for i, v in ipairs(tokenTypes) do
					-- 	local tmp = string.gsub(v, ' ', '_')
					-- 	tokenTypes[i] = string.gsub(tmp, '-_', '')
					-- end
				-- END WORKAROUND INVALID CHAR GROUP ISSUE WITH OMNISHARP
					-- COMMENTED IT OUT ON 14 SEP 2023, BECAUSE IT SEEMS TO BE FIXED IN THE LATEST VERSION OF OMNISHARP
					-- COMMENTED IT OUT ON 14 SEP 2023, BECAUSE IT SEEMS TO BE FIXED IN THE LATEST VERSION OF OMNISHARP
					-- COMMENTED IT OUT ON 14 SEP 2023, BECAUSE IT SEEMS TO BE FIXED IN THE LATEST VERSION OF OMNISHARP

					-- on_attach(client, bufnr)
				end,
			}
			vim.g.dotnetlsp = "omnisharp_mono"
			vim.cmd('LspStart omnisharp_mono')
		elseif frameworkType == "netcore" then
			print("Found a .NET Core project, starting .NET Core OmniSharp")
			require'lspconfig'.omnisharp.setup {
				organize_imports_on_format = true,
				on_attach = function (client, bufnr)

					--- Guard against servers without the signatureHelper capability
					if client.server_capabilities.signatureHelpProvider then
						require('lsp-overloads').setup(client, { })

			-- ...
			-- keymaps = {
			-- 		next_signature = "<C-j>",
			-- 		previous_signature = "<C-k>",
			-- 		next_parameter = "<C-l>",
			-- 		previous_parameter = "<C-h>",
			-- 		close_signature = "<A-s>"
			-- 	},
			-- ...


					end

					-- WORKAROUND INVALID CHAR GROUP ISSUE WITH OMNISHARP
					-- FROM: https://github.com/OmniSharp/omnisharp-roslyn/issues/2483#issuecomment-1515504374
					-- 	-- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483#issuecomment-1492605642
					-- 	local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
					-- 	for i, v in ipairs(tokenModifiers) do
					-- 		local tmp = string.gsub(v, ' ', '_')
					-- 		tokenModifiers[i] = string.gsub(tmp, '-_', '')
					-- 	end
					-- 	local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
					-- 	for i, v in ipairs(tokenTypes) do
					-- 		local tmp = string.gsub(v, ' ', '_')
					-- 		tokenTypes[i] = string.gsub(tmp, '-_', '')
					-- 	end
					-- END WORKAROUND INVALID CHAR GROUP ISSUE WITH OMNISHARP

					-- on_attach(client, bufnr)
				end,
			}
			vim.g.dotnetlsp = "omnisharp"
			vim.cmd('LspStart omnisharp')
		else
			-- print("No .csproj file found")
			return
		end
	end,
	group = vim.api.nvim_create_augroup("_nvim-lspconfig.lua.filetype.csharp", { clear = true })
})

require'lspconfig'.lua_ls.setup{
	settings = {
		Lua = {
			diagnostics = {
				globals = { 'vim' }
			}
		}
	}
}

require'lspconfig'.tsserver.setup{}


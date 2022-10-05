local maps = vim.api.nvim_get_var('IDE_mappings')
-- Mappings.
-- See `:help vim.lsp.*` for documentation on any of the below functions
local lsp_nbufmaps = {
   ['<space>wa'] = 'buf.add_workspace_folder()',
   [maps.implementation] = 'buf.declaration()',
   [maps.implementation2] = 'buf.declaration()',
   [maps.definition] = 'buf.definition()',
   [maps.documentation] = 'buf.hover()',
   [maps.documentation2] = 'buf.hover()',
   [maps.documentation3] = 'buf.hover()',
   [maps.implementation] = 'buf.implementation()',
   [maps.implementation2] = 'buf.implementation()',
   [maps.type_definition] = 'buf.type_definition()',
   [maps.type_definition2] = 'buf.type_definition()',
   [maps.rename] = 'buf.rename()',
   [maps.codeAction] = 'buf.code_action()',
   [maps.references] = 'buf.references()',
   [maps.diagnostic] = 'diagnostic.show_line_diagnostics()',
   [maps.diagnostic_next] = 'diagnostic.goto_prev()',
   [maps.diagnostic_prev] = 'diagnostic.goto_next()',
   [maps.reformat] = 'buf.formatting()',
--  ['<space>wr'] = 'buf.remove_workspace_folder()',
--  ['<space>wl'] = '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))',
--  ['<space>q'] = 'diagnostic.set_loclist()',
}

nvim_lsp = require('lspconfig')
require("mason").setup()


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
   local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
   local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

   --Enable completion triggered by <c-x><c-o>
   buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

   -- Mappings.
   local opts = { noremap=true, silent=true }
   for key, cmd in pairs(to_bufmap) do
      buf_set_keymap('n', key, "<cmd>lua vim.lsp." .. cmd .. "()<CR>", opts)
   end
end


local lsp_installer = require("mason-lspconfig")

lsp_installer.setup({
      -- ensure_installed = { "pylsp" },
   })

-- Register a handler that will be called for each installed server when it's
-- ready (i.e. when installation is finished or if the server is already
-- installed).
lsp_installer.setup_handlers{
   function (server_name) -- default handler (optional)
      require("lspconfig")[server_name].setup {}
   end,

   -- (optional) Customize the options passed to the server
   ["pylsp"] = function ()
      require('lspconfig').pylsp.setup {}
      -- vim.cmd("UnPlug 'davidhalter/jedi-vim'")
      -- vim.cmd("let g:jedi#auto_initialization = 0")
      vim.cmd("let g:pymode = 0")
      vim.cmd("silent! au! myPymode")
   end
}

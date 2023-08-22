if vim.g.ideMode==0 then
  return {}
end

local maps = vim.api.nvim_get_var('IDE_mappings')

-- https://github.com/ray-x/lsp_signature.nvim
vim.o.completeopt = "menuone,noselect"
local cmp_buffer = require('cmp_buffer')

Get_bufnrs_to_complete_from = function()
  -- Include all visible buffers (not just default of current one) below a certain size.
  local bufs = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local byte_size = vim.api.nvim_buf_get_offset(
      buf, vim.api.nvim_buf_line_count(buf))
    if byte_size < 1024 * 1024 then -- 1 Megabyte max
      bufs[buf] = true
    end
  end
  return vim.tbl_keys(bufs)
end

return {
  {'hrsh7th/nvim-cmp',
    opts={
      -- debug = false;
      -- min_length = 1;
      preselect = require'cmp'.PreselectMode.None;
      -- view = {
      --   entries = {name = 'custom', selection_order = 'near_cursor' }
      -- },
      performance = {
        debounce = 200,
        throttle = 1,
      },

      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
          -- require('luasnip').lsp_expand(args.body)
        end,
      },

      sources = require'cmp'.config.sources({
        { name = "nvim_lsp",
          entry_filter = function(entry, ctx)
            -- Dont suggest Text from nvm_lsp
            return require('require'cmp'.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
          end },
        {
          name = 'buffer',
          option = {
            keyword_length = 2,
            get_bufnrs = Get_bufnrs_to_complete_from,
          },
          sorting = {
            comparators = {
              function(...) return cmp_buffer:compare_locality(...) end,
            },
          }
        },
        { name = 'vsnip' },
        { name = 'path' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'vim-dadbod-completion' },
        {
          name = 'spell',
          option = {
            keep_all_entries = false,
            enable_in_context = function()
              -- Could also only enable in prose FTs...
              return vim.opt.spell:get()
            end,
          },
        },
        sorting = {
          comparators = {
            function(...) return cmp_buffer:compare_locality(...) end,
          }
        }
      }),

      mapping = {
        ['<C-e>'] = require'cmp'.mapping.confirm({ select = false }),
        -- Because I tab and go, the current selection when I push space is already the one I want.
        -- But this _is_ useful for snippets, because they will be expanded, not just selected.
        ['<space>'] = function(fallback)
          if require'cmp'.visible() and require'cmp'.expandable then
            require'cmp'.mapping.confirm({ select = false })
            vim.fn.feedkeys(' ')
          else
            fallback()
          end
        end,
        ["<Tab>"] = require'cmp'.mapping(function(fallback)
          if require'cmp'.visible() then
            require'cmp'.select_next_item()
          else
            fallback()
          end
        end, {'i', 'c'}),
        ["<S-Tab>"] = require'cmp'.mapping(function(fallback)
          if require'cmp'.visible() then
            require'cmp'.select_prev_item()
          else
            fallback()
          end
        end, {'i', 'c'}),
        ['<C-b>'] = require'cmp'.mapping(require'cmp'.mapping.scroll_docs(-4), { 'i' }),
        ['<C-f>'] = require'cmp'.mapping(require'cmp'.mapping.scroll_docs(4), { 'i' }),
      },

    },

    config=function ()

      require'cmp'.setup.cmdline(':', {
        sources = require'cmp'.config.sources({
          { name = 'path' },
          { name = 'cmdline' }
        })
      })

      require'cmp'.setup.cmdline('/', {
        sources = require'cmp'.config.sources({
          { name = 'buffer' },
          { name = 'nvim_lsp_document_symbol' }
        })
      })

      -- Load vsnip when file opens, to avoid lag on insert mode.
      -- Will see whether this slows down opening a file though...
      vim.api.nvim_exec([[
autocmd InsertEnter * call vsnip#get_complete_items(bufnr())
]], false)

      -- Debounce tabstop syncing.
      vim.g.vsnip_sync_delay = 20
      vim.g.vsnip_choice_delay = 250

    end
  }

  -- -- Tab and S-Tab keys need to be mapped to <C-n> and <C-p> when completion menu is visible. Following example will use Tab and S-Tab (shift+tab) to navigate completion menu and jump between vim-vsnip placeholders when possible:

  -- local t = function(str)
  --   return vim.api.nvim_replace_termcodes(str, true, true, true)
  -- end

  -- local check_back_space = function()
  --     local col = vim.fn.col('.') - 1
  --     return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
  -- end

  -- -- Use (s-)tab to:
  -- --- move to prev/next item in completion menuone
  -- --- jump to prev/next snippet's placeholder
  -- _G.tab_complete = function()
  --   if vim.fn.pumvisible() == 1 then
  --     return t "<C-n>"
  --   elseif vim.fn['vsnip#available'](1) == 1 then
  --     return t "<Plug>(vsnip-expand-or-jump)"
  --   elseif check_back_space() then
  --     return t "<Tab>"
  --   else
  --     return vim.fn['require'cmp'#complete']()
  --   end
  -- end
  -- _G.s_tab_complete = function()
  --   if vim.fn.pumvisible() == 1 then
  --     return t "<C-p>"
  --   elseif vim.fn['vsnip#jumpable'](-1) == 1 then
  --     return t "<Plug>(vsnip-jump-prev)"
  --   else
  --     -- If <S-Tab> is not working in your terminal, change it to <C-h>
  --     return t "<S-Tab>"
  --   end
  -- end

  -- vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
  -- vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
  -- vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
  -- vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/cmp-buffer'},
  {'hrsh7th/cmp-path'},
  {'hrsh7th/cmp-vsnip'},
  {'hrsh7th/cmp-nvim-lsp-signature-help'},
  {'hrsh7th/cmp-nvim-lsp-document-symbol'},
  {'https://github.com/f3fora/cmp-spell'},

}

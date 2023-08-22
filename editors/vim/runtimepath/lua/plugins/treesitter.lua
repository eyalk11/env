if vim.g.ideMode==0 then
  return {}
end

function check_treesitter_installable()
   -- ("tar" and "curl" or "git") and {
   local fn = vim.fn
   if fn.Executable("git") == 0 then
      if fn.Executable("curl") == 0 and fn.executable("tar") == 0 then
         return false
      end
   end
   if not fn.IsCCompilerAvailable() then
      return false
   end
   return true
end

if not check_treesitter_installable() then
   return {'nvim-treesitter/nvim-treesitter.git', enabled=false}
end

return {
   {'https://github.com/nvim-treesitter/nvim-treesitter.git',
      build= ':TSUpdate'
   },
   {'nvim-treesitter/playground'},

   {'https://github.com/ThePrimeagen/refactoring.nvim'},
   {'https://github.com/danymat/neogen'},
   {'https://github.com/RRethy/nvim-treesitter-endwise'},
   {'nvim-treesitter/nvim-treesitter-context'},
   {'nvim-treesitter/nvim-treesitter-textobjects'},
   {'PeterRincker/vim-argumentative', enabled=false},
   {'https://github.com/JoosepAlviste/nvim-ts-context-commentstring'},
   {'https://github.com/Wansmer/treesj'},
   {'kevinhwang91/promise-async'},
   {'https://github.com/kevinhwang91/nvim-ufo'},
   {'Konfekt/FastFold', enabled=false},
   {'https://gitlab.com/HiPhish/rainbow-delimiters.nvim'},

   {'https://github.com/cshuaimin/ssr.nvim',
      cmd='SSR',
      config=function()
         vim.api.nvim_create_user_command('SSR', function() require("ssr").open() end)
      end
   -- lua vim.keymap.set({ "n", "x" }, "<leader>sr", function() require("ssr").open() end)
   },

}

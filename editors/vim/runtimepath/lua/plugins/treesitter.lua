if vim.g.ideMode == 0 then
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
	return { "nvim-treesitter/nvim-treesitter", enabled = false }
end

local maps = vim.g.IDE_mappings

-- Cache treesitter parsers
local parser_install_dir = vim.fn.stdpath("data") .. "/treesitter"
vim.opt.runtimepath:append(parser_install_dir)

local specs = {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			require"nvim-treesitter-context"
		end,
		opts = {
			parser_install_dir = parser_install_dir,
			auto_install = false,
			ensure_installed = {
				"bash",
				"json",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"r",
				"regex",
				"sql",
				"toml",
				"vim",
				"yaml",
				-- "powershell", -- not available yet
			},
			endwise = { enable = true },
			indent = {
				enable = true,
				disable = { "python" },
			},
			highlight = {
				enable = true,
				-- additional_vim_regex_highlighting = {"python"}
			},
		},
	},

	{
		"https://github.com/ThePrimeagen/refactoring.nvim.git",
		config = function()
			require("telescope").load_extension("refactoring")
		end,
		keys = {
			{
				maps.refactor,
				function()
					require("telescope").extensions.refactoring.refactors()
				end,
				mode = { "n", "v" },
			},
		},
	},

	-- generate annotations (eg docstrings)
	{
		"https://github.com/danymat/neogen.git",
		config = function()
			vim.cmd("command! Annotate lua require('neogen').generate()")
		end,
		cmd = "Annotate",
	},
	{ "https://github.com/RRethy/nvim-treesitter-endwise.git", lazy=true },

	{ "nvim-treesitter/nvim-treesitter-context", lazy=true },

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		keys = {
			{'a', mode={'o'}},
			{'i', mode={'o'}},
			{']'},
			{'['},
			{'>,'},
			{'<,'},
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,
						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,
						keymaps = {
							["a,"] = "@parameter.outer",
							["i,"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							-- { query = "@class.inner", desc = "Select inner part of a class region" }
						},
						selection_modes = {
							["@parameter.outer"] = "v", -- charwise
							["@function.outer"] = "V", -- linewise
							["@class.outer"] = "V",
						},
						-- Can also be a function which gets passed a table with the keys
						-- * query_string: eg '@function.inner'
						-- * selection_mode: eg 'v'
						-- and should return true of false
						include_surrounding_whitespace = true,
					},
					swap = {
						enable = true,
						swap_next = {
							[">,"] = "@parameter.inner",
						},
						swap_previous = {
							["<,"] = "@parameter.inner",
						},
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = { query = "@class.outer", desc = "Go to next class start" },
						["],"] = { query = "@parameter.inner", desc = "Go to next argument" },
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
						["[,"] = { query = "@parameter.inner", desc = "Go to previous argument" },
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
				},
			})
		end,
	},

	{ "PeterRincker/vim-argumentative", enabled = false },

	{
		"https://github.com/JoosepAlviste/nvim-ts-context-commentstring.git",
		config = function()
			require("nvim-treesitter.configs").setup({
				context_commentstring = {
					enable = true,
				},
			})
		end,
		dependencies = { "nvim-treesitter/nvim-treesitter-context" },
	},

	{ "kevinhwang91/promise-async" },

	{
		"https://github.com/kevinhwang91/nvim-ufo.git",
		config = function()
			-- vim.o.foldcolumn = '1' -- '0' is not bad
			-- Have to override foldlevelstart, otherwise constantly closes folds on save.
			vim.o.foldlevelstart = 99
			vim.o.foldlevel = 99
			vim.o.foldenable = true
			-- Not for lazy loading!
			-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
			vim.keymap.set("n", "zR", require("ufo").openAllFolds)
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
		end,
		opts = {
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
		},
	},
	{ "Konfekt/FastFold", enabled = false },

	{ "https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git", event="VeryLazy"},

	{
		"https://github.com/cshuaimin/ssr.nvim.git",
		cmd = "SSR",
		config = function()
			vim.api.nvim_create_user_command("SSR", function()
				require("ssr").open()
			end)
		end,
		-- lua vim.keymap.set({ "n", "x" }, "<leader>sr", function() require("ssr").open() end)
	},

	{
		"https://github.com/Wansmer/treesj.git",
		opts = { use_default_keymaps = false },
		keys = {
			{
				"gJ",
				function()
					require("treesj").join()
				end,
			},
			{
				"gS",
				function()
					require("treesj").split()
				end,
			},
		},
	},
}

for _, spec in ipairs(specs) do
	if spec[1] ~= "nvim-treesitter/nvim-treesitter" then
		spec.dependencies = "nvim-treesitter/nvim-treesitter"
	end
end

return specs
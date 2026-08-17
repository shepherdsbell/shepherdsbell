-- ==========================================================================
-- 1. SETTINGS & LEADER
-- ==========================================================================
vim.opt.conceallevel = 2        -- Essential for hiding markdown syntax
vim.opt.concealcursor = 'nc'    -- Hides syntax in Normal/Command mode
vim.g.mapleader = " " 
vim.opt.number = true          
vim.opt.relativenumber = true  
vim.opt.mouse = 'a'            

local notes_path = "/home/puppy/notes"

-- ==========================================================================
-- 2. BOOTSTRAP LAZY.NVIM
-- ==========================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ==========================================================================
-- 3. PLUGIN SETUP
-- ==========================================================================
require("lazy").setup({
  { "AlphaTechnolog/pywal.nvim", name = "pywal" },
  {
    'goolord/alpha-nvim',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    'nvim-telescope/telescope.nvim', 
    tag = '0.1.5',
    lazy = false,
    priority = 1000,
    dependencies = { 
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-file-browser.nvim'
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        extensions = {
          file_browser = {
            theme = "ivy",
            hijack_netrw = true,
            hidden = true,
          },
        },
      })
      telescope.load_extension("file_browser")
    end
  },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- RENDER-MARKDOWN: This hides the ![]() and makes it look like an app
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    opts = {
      anti_conceal = { enabled = true }, -- Shows syntax only when cursor is on the line
    },
  },

  -- IMAGE.NVIM: Renders the actual image
  {
    "3rd/image.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("image").setup({
        backend = "kitty", 
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
          },
        },
      })
    end,
  },
})

-- ==========================================================================
-- 4. THEME CONFIGURATION
-- ==========================================================================
require('pywal').setup({ transparent_background = true })
vim.cmd.colorscheme("pywal")

-- ==========================================================================
-- 5. DASHBOARD (ALPHA)
-- ==========================================================================
local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

dashboard.section.header.val = {
    [[          __          ]],
    [[  ,.    ," ,`-o      ]],
    [[ (_(   (  | _,'      ]],
    [[  \ `-' `-' (__      ]],
    [[  (         `--.'      ]],
    [[  /)  .__,`--~'      ]],
    [[ ((  (                ]],
    [[   `'''              ]],
}

dashboard.section.buttons.val = {
    dashboard.button("n", "  Notes", ":Telescope file_browser path=" .. notes_path .. " <CR>"),
    dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
    dashboard.button("c", "  Config", ":e $MYVIMRC <CR>"),
    dashboard.button("q", "  Quit", ":qa<CR>"),
}
alpha.setup(dashboard.opts)

-- ==========================================================================
-- 6. ROBUST AUTO-MARKDOWN FOR NOTES
-- ==========================================================================
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    pattern = notes_path .. "/*",
    callback = function()
        local full_path = vim.fn.expand("%:p")
        local extension = vim.fn.expand("%:e")

        if extension == "" and full_path:find(notes_path, 1, true) then
            vim.bo.filetype = "markdown"
            local new_name = full_path .. ".md"
            vim.api.nvim_buf_set_name(0, new_name)
        end
    end,
})

-- ==========================================================================
-- 7. KEYMAPS & PICKER FUNCTIONS
-- ==========================================================================

-- Custom picker: Uses Neovim's UI to pick a file (works great with Telescope)
local function insert_image_link()
    vim.ui.input({ prompt = 'Insert Image Path: ', completion = 'file' }, function(input)
        if input and input ~= "" then
            local link = string.format("![image](%s)", input)
            vim.api.nvim_put({link}, "c", true, true)
        end
    end)
end

-- Keybinds
vim.keymap.set("n", "<leader>i", insert_image_link, { desc = "Insert Image Link" })

vim.keymap.set("n", "<leader>e", function()
    require("telescope").extensions.file_browser.file_browser({
        path = vim.fn.expand("%:p:h"),
        select_buffer = true
    })
end)

vim.keymap.set("n", "<leader>n", function()
    require("telescope").extensions.file_browser.file_browser({
        path = notes_path
    })
end)

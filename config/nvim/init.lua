vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("config") .. "/plugins/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  root = vim.fn.stdpath("config") .. "/plugins",
  spec = {
    { "nvim-tree/nvim-tree.lua", dependencies = "nvim-tree/nvim-web-devicons" },
    { "nvim-lualine/lualine.nvim" },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "goolord/alpha-nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = { "nvim-lua/plenary.nvim" } },
    { "karb94/neoscroll.nvim" }
  }
})

require('neoscroll').setup({
    mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
    hide_cursor = true,
    stop_eof = true,
    respect_scrolloff = false,
    cursor_scroll_step = 1
})

vim.cmd("source ~/.config/nvim/colors/colors.vim")

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.guicursor = "a:hide"

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#4a6991", bg = "none" })

require("lualine").setup({
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = '',
    section_separators = '',
    globalstatus = false,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  }
})

require("nvim-tree").setup({ filters = { dotfiles = true } })

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
dashboard.section.buttons.val = {}
dashboard.section.footer.val = ""
dashboard.section.header.val = {
    " ",
    "   コードを書く者   ",
    " ",
    "   [F] - Write      ",
    "   [S] - Select     ",
    "   [H] - Done       ",
    "   [G] - Ghost      ",
    "   [FF] - Filter    ",
    "   [SS] - Search    ",
    " ",
}
alpha.setup(dashboard.config)

vim.keymap.set("n", "f", "i")
vim.keymap.set("i", "h", "<Esc>")
vim.keymap.set("n", "s", ":NvimTreeToggle<CR>", { silent = true })
vim.keymap.set("n", "g", ":NvimTreeFocus<CR>H", { silent = true })
vim.keymap.set("n", "ff", ":NvimTreeFocus<CR>f", { silent = true })
vim.keymap.set("n", "ss", ":Telescope live_grep<CR>", { silent = true })
vim.keymap.set("n", "A", ":NvimTreeFocus<CR>a", { silent = true })

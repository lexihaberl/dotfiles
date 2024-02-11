-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>wn", "<C-w>h", { desc = "Go to left window", remap = true })
vim.keymap.set("n", "<leader>we", "<C-w>j", { desc = "Go to lower window", remap = true })
vim.keymap.set("n", "<leader>wi", "<C-w>k", { desc = "Go to upper window", remap = true })
vim.keymap.set("n", "<leader>wo", "<C-w>l", { desc = "Go to right window", remap = true })

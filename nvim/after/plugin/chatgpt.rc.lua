local status, chatgpt = pcall(require, 'chatgpt')

if (not status) then return end

local api_key_cmd = "doppler --config neovim --project neovim-config secrets get OPENAI_API_KEY --plain"
local model = "gpt-3.5-turbo"
local edit_model = "code-davinci-edit-001"

local options = { noremap = true }
vim.api.nvim_set_keymap('n', '<leader>ga', '<CMD>ChatGPTActAs<CR>', options)
vim.api.nvim_set_keymap('n', '<leader>gg', '<CMD>ChatGPT<CR>', options)
vim.api.nvim_set_keymap('v', '<leader>ge', '<CMD>ChatGPTEditWithInstructions<CR>', options)
vim.api.nvim_set_keymap('v', '<leader>go', '<CMD>ChatGPTRun optimize_code<CR>', options)
vim.api.nvim_set_keymap('v', '<leader>gs', '<CMD>ChatGPTRun summarize<CR>', options)
vim.api.nvim_set_keymap('v', '<leader>gt', '<CMD>ChatGPTRun add_tests<CR>', options)
chatgpt.setup({
    api_key_cmd = api_key_cmd,
    openai_params = {
        model = model
    },
    openai_edit_params = {
        model = edit_model }
})

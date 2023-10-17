-- In order to see buffers like tabs
return {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    opts = {
        options = {
            mode = 'tabs',
            --separator_style = 'slant',
            always_show_bufferline = false,
            show_buffer_close_icons = false,
            show_close_icons = false,
        },
    },
    init = function()
        vim.api.nvim_set_keymap('n', '<Tab>', '<cmd>BufferLineCycleNext<cr>', {})
        vim.api.nvim_set_keymap('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<cr>', {})
    end
}

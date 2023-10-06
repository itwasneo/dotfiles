local status, ts = pcall(require, 'nvim-treesitter.configs')

if (not status) then return end

ts.setup {
    auto_install = false,
    autotag = {
        enable = true
    },
    ensure_installed = {
        'rust',
        'java',
        'lua',
        'json',
        'css',
        'html',
        'toml',
        'yaml',
        'markdown',
        'markdown_inline'
    },
    highlight = {
        enable = true,
        disable = { 'html' },
    },
    indent = {
        enable = true,
        disable = { "yaml" }
    },
    ignore_install = {},
    modules = {},
    sync_install = false,
}

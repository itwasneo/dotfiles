local status, ts = pcall(require, 'nvim-treesitter.configs')

if (not status) then return end

ts.setup {
    highlight = {
        enable = true,
        disable = { 'html' },
    },
    indent = {
        enable = true,
        disable = { "yaml" }
    },
    ensure_installed = {
        'rust',
        'lua',
        'json',
        'css',
        'html',
        'toml',
        'yaml',
        'markdown',
        'markdown_inline'
    },
    sync_install = false,
    autotag = {
        enable = true
    },
}

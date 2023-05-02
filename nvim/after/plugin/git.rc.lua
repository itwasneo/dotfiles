local status, git = pcall(require, 'git')

if (not status) then return end

git.setup {
    keymaps = {
        blame = "<Leader>gb",     -- Open blame window
        browse = "<Leader>go",    -- Open file/folder
        diff = "<Leader>gd",      -- Opens a new diff that compares against the current index
        diff_close = "<Leader>gD" -- Close git diff
    }
}

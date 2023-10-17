return {
    "dinhhuy258/git.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        keymaps = {
            blame = "<Leader>gb",      -- Open blame window
            browse = "<Leader>go",     -- Open file/folder
            diff = "<Leader>gd",       -- Opens a new diff that compares against the current index
            diff_close = "<Leader>gdc" -- Close git diff
        }
    }
}

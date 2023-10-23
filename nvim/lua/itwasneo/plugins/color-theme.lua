return {
    "itwasneo/silense.nvim",
    priority = 1000,
    config = function()
        require("silense").setup({
            comment_italics = true,
            set_background = false,
        })
    end
}

return {
    "itwasneo/silense.nvim",
    priority = 1000,
    dependencies = {
        "tjdevries/colorbuddy.nvim",
    },
    config = function()
        require("silense").setup({
            comment_italics = true,
        })
    end
}

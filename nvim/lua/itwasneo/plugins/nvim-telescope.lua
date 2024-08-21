return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "nvim-telescope/telescope-file-browser.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    init = function()
        local telescope = require("telescope")
        local t_actions = require("telescope.actions")
        local f_actions = require("telescope").extensions.file_browser.actions
        telescope.setup({
            defaults = {
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--hidden",
                    "--trim", -- Removes indentation for found lines
                },
                mappings = {
                    n = {
                        ["q"] = t_actions.close,
                    },
                },
            },
            pickers = {
                buffers = {
                    mappings = {
                        i = {
                            ["<c-d>"] = t_actions.delete_buffer + t_actions.move_to_top,
                        },
                    },
                },
            },
            extensions = {
                file_browser = {
                    theme = "dropdown",
                    previewer = false,
                    -- disables netrw and uses telescope-file-browser in its place
                    hijack_netrw = true,
                    mappings = {
                        ["i"] = {
                            ["<C-w>"] = function()
                                vim.cmd("normal vbd")
                            end,
                        },
                        ["n"] = {
                            ["N"] = f_actions.create,
                            ["D"] = f_actions.remove,
                            ["R"] = f_actions.rename,
                            ["M"] = f_actions.move,
                            ["h"] = f_actions.goto_parent_dir,
                            ["<c-h>"] = f_actions.toggle_hidden,
                            ["/"] = function()
                                vim.cmd("startinsert")
                            end,
                        },
                    },
                },
            },
        })

        telescope.load_extension("file_browser")

        local opts = { noremap = true, silent = true }
        local keymap = vim.keymap
        keymap.set("n", ";f", "<cmd>Telescope find_files layout_strategy=vertical<cr>", opts)
        keymap.set("n", ";r", "<cmd>Telescope live_grep layout_strategy=vertical<cr>", opts)
        keymap.set("n", ";t", "<cmd>Telescope help_tags<cr>", opts)
        keymap.set("n", ";e", "<cmd>Telescope diagnostics<cr>", opts)
        keymap.set("n", ";;", "<cmd>Telescope resume<cr>", opts)
        keymap.set("n", "sf", "<cmd>Telescope file_browser initial_mode=normal path=%:p:h select_buffer=true<cr>", opts)
        keymap.set("n", "\\\\", "<cmd>Telescope buffers<cr>", opts)
    end,
}

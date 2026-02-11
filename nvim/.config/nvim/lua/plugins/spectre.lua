return {
    "nvim-pack/nvim-spectre",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("spectre").setup({
            color_devicons = true,
            open_cmd = "vnew",
            live_update = true, -- Auto-update search results as you type
            line_sep_start = "┌-----------------------------------------",
            result_padding = "¦  ",
            line_sep = "└-----------------------------------------",
            highlight = {
                ui = "String",
                search = "DiffChange",
                replace = "DiffDelete"
            },
            mapping = {
                ["tab"] = {
                    map = "<Tab>",
                    cmd = "<cmd>lua require('spectre').tab()<cr>",
                    desc = "next query"
                },
                ["run_replace"] = {
                    map = "<leader>R",
                    cmd = "<cmd>lua require('spectre.actions').run_replace()<cr>",
                    desc = "replace all"
                },
                ["change_view_mode"] = {
                    map = "<leader>v",
                    cmd = "<cmd>lua require('spectre').change_view()<cr>",
                    desc = "toggle result view"
                },
                ["toggle_ignore_case"] = {
                    map = "ti",
                    cmd = "<cmd>lua require('spectre').change_options('ignore-case')<cr>",
                    desc = "toggle ignore case"
                },
                ["toggle_ignore_hidden"] = {
                    map = "th",
                    cmd = "<cmd>lua require('spectre').change_options('hidden')<cr>",
                    desc = "toggle search hidden"
                },
            },
            find_engine = {
                -- rg is map with finder_cmd
                ["rg"] = {
                    cmd = "rg",
                    -- default args
                    args = {
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                    },
                    options = {
                        ["ignore-case"] = {
                            value = "--ignore-case",
                            icon = "[I]",
                            desc = "ignore case"
                        },
                        ["hidden"] = {
                            value = "--hidden",
                            icon = "[H]",
                            desc = "hidden file"
                        },
                    }
                },
            },
            replace_engine = {
                ["sed"] = {
                    cmd = "sed",
                    cmd_error = "sed",
                },
            },
            default = {
                find = {
                    -- pick one of item in find_engine
                    cmd = "rg",
                    options = { "ignore-case" }
                },
                replace = {
                    -- pick one of item in replace_engine
                    cmd = "sed"
                }
            },
        })

        -- Keymaps to open Spectre
        vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
            desc = "Toggle Spectre"
        })
        vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
            desc = "Search current word"
        })
        vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
            desc = "Search selected word"
        })
        vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
            desc = "Search on current file"
        })
    end,
}

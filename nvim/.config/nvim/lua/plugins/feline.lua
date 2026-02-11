return {
  "famiu/feline.nvim",
  event = "VeryLazy",
  dependencies = {
    "lewis6991/gitsigns.nvim", -- Required for git providers
  },
  config = function()
    local vi_mode = require("feline.providers.vi_mode")

    -- Dark pastel color palette
    local colors = {
      bg = "#1E1E2E",
      fg = "#CDD6F4",
      blue = "#89B4FA",
      cyan = "#89DCEB",
      green = "#A6E3A1",
      yellow = "#F9E2AF",
      orange = "#FAB387",
      red = "#F38BA8",
      pink = "#F5C2E7",
      purple = "#CBA6F7",
      lavender = "#B4BEFE",
      surface0 = "#313244",
      surface1 = "#45475A",
    }

    local components = {
      active = { {}, {}, {} }, -- left, mid, right
      inactive = { {}, {} },   -- left, right
    }

    -- LEFT SECTION
    -- Vi mode indicator
    table.insert(components.active[1], {
      provider = "vi_mode",
      hl = function()
        return {
          name = vi_mode.get_mode_highlight_name(),
          fg = colors.bg,
          bg = vi_mode.get_mode_color(),
          style = "bold",
        }
      end,
      right_sep = {
        str = "slant_right",
        hl = function()
          return {
            fg = vi_mode.get_mode_color(),
            bg = colors.surface1,
          }
        end,
      },
      icon = "",
    })

    -- File info
    table.insert(components.active[1], {
      provider = {
        name = "file_info",
        opts = {
          type = "relative",
          file_modified_icon = " ●",
        },
      },
      hl = {
        fg = colors.fg,
        bg = colors.surface1,
        style = "bold",
      },
      right_sep = {
        str = "slant_right",
        hl = {
          fg = colors.surface1,
          bg = colors.bg,
        },
      },
    })

    -- RIGHT SECTION
    -- Git diff added
    table.insert(components.active[3], {
      provider = "git_diff_added",
      hl = {
        fg = colors.green,
        bg = colors.bg,
      },
      left_sep = " ",
      icon = " +",
    })

    -- Git diff changed
    table.insert(components.active[3], {
      provider = "git_diff_changed",
      hl = {
        fg = colors.yellow,
        bg = colors.bg,
      },
      left_sep = " ",
      icon = " ~",
    })

    -- Git diff removed
    table.insert(components.active[3], {
      provider = "git_diff_removed",
      hl = {
        fg = colors.red,
        bg = colors.bg,
      },
      left_sep = " ",
      icon = " -",
    })

    -- Git branch
    table.insert(components.active[3], {
      provider = "git_branch",
      hl = {
        fg = colors.fg,
        bg = colors.surface1,
        style = "bold",
      },
      left_sep = {
        str = "slant_left",
        hl = {
          fg = colors.surface1,
          bg = colors.bg,
        },
      },
      right_sep = " ",
      icon = " ",
    })

    -- INACTIVE STATUSLINE
    table.insert(components.inactive[1], {
      provider = {
        name = "file_info",
        opts = {
          type = "relative",
        },
      },
      hl = {
        fg = colors.surface1,
        bg = colors.bg,
      },
      left_sep = " ",
      right_sep = " ",
    })

    require("feline").setup({
      components = components,
      theme = colors,
    })
  end,
}

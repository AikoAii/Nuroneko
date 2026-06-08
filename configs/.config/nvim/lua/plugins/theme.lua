return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      styles = {
        comments = { "italic" },
        keywords = { "italic" },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")

      vim.cmd([[
        highlight Normal guibg=NONE
        highlight NormalNC guibg=NONE
        highlight EndOfBuffer guibg=NONE
        highlight SignColumn guibg=NONE
        highlight VertSplit guibg=NONE

        highlight NormalFloat guibg=NONE
        highlight FloatBorder guibg=NONE
        highlight Pmenu guibg=NONE

        highlight TelescopeNormal guibg=NONE
        highlight TelescopeBorder guibg=NONE

        highlight NvimTreeNormal guibg=NONE
        highlight WhichKeyFloat guibg=NONE
      ]])
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}

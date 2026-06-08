return {
  "folke/which-key.nvim",
  opts = {
    win = {
      border = "rounded",
    },
  },
  config = function(_, opts)
    require("which-key").setup(opts)

    vim.cmd([[
      highlight WhichKeyFloat guibg=NONE
      highlight WhichKeyBorder guibg=NONE
      highlight NormalFloat guibg=NONE
    ]])
  end,
}

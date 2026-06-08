return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP
        "clangd",
        "typescript-language-server",
        "html-lsp",
        "css-lsp",
        "tailwindcss-language-server",
        "lua-language-server",
        "json-lsp",
        "yaml-language-server",

        -- FORMATTER
        "prettier",
        "stylua",
        "clang-format",

        -- LINTER
        "eslint-lsp",

        -- DEBUGGER
        "codelldb",
        "js-debug-adapter",
      },
    },
  },
}

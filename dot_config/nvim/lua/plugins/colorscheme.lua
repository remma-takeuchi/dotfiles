return {
  {
    "Tsuzat/NeoSolarized.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      vim.cmd.colorscheme("NeoSolarized")
    end,
  },
}

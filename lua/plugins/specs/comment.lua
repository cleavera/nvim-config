return {
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup {
      mapping = false,
      toggler = {
        line = "<C-/>",
      }
    }
  end,
}

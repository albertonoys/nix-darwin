require "nvchad.options"

-- add yours here!

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.keymap",
  callback = function()
    vim.bo.filetype = "devicetree"
  end
})

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

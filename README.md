# Denty.nvim

- native indent line characters
- auto detect tabs/spaces from buffer content and sets `tabstop`, `shiftwidth`, and `expandtab`

<img width="100%" alt="preview of indent character in neovim buffers" src="https://github.com/antonk52/dot-files/assets/5817809/c3e3c6b9-c0a9-4984-9cb8-42d608d4505e">

## Installation

```lua
-- lazy.nvim
require('lazy').setup({
  -- other plugins
  {
    'antonk52/denty.nvim',
    -- optionally
    config = function()
      require('denty').setup({
        -- defaults

        -- enable updating indentation characters
        enable_indent_char = true,

        -- character used for space indentation
        indent_space_char = '│',

        -- character used for tab indentation
        indent_tab_char = '▸',

        -- if denty wasn't able to infer indentation of a buffer
        -- this option will be used
        default_space_indentation = 2,

        -- do not update indentation characters in these buffers
        exclude_filetypes = { 'help', 'packer', 'lazy', 'markdown' },
      })
    end
  }
})
```

## Usage

Once the setup function was called you no longer have to do anything. `denty` will detect what indent characters are used in your buffer and apply settings accordingly

If you do not want to use for indent characters you can pass `disable_indent_char = true` to `setup` function

You can highlight them using `NonText` highlighting group.

## Warning

This plugin uses builtin vim functionality `listchars` to draw indentation levels. For this reason empty lines do not have an indentation character(screenshot below). If you want these, you can check out [`nvimdev/indentmini.nvim`](https://github.com/nvimdev/indentmini.nvim). Wrapped lined also won't have indentation character.

<img width="391" alt="Screenshot 2023-10-14 at 14 32 06" src="https://github.com/antonk52/dot-files/assets/5817809/7d30ee39-8d46-4e2c-a8ae-3e6d76b83010">

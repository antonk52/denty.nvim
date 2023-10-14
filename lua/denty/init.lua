local M = {}

local function update_listchars_for_spaces(space_count, indent_char)
  local leadmultispace = indent_char..(' '):rep(space_count - 1)
  -- use opt_local to set buffer-local options
  -- this avoids overriding global options
  -- and does not conflict with other buffers
  vim.opt_local.listchars:append({ leadmultispace = leadmultispace })
end

M.default_opts = {
  enable_indent_char = true,
  indent_space_char = '│',
  indent_tab_char = '▸',
  default_space_indentation = 2,
  exclude_filetypes = { 'help', 'packer', 'lazy', 'markdown' },
}

M.setup = function(opts)
  local options = vim.tbl_extend('force', M.default_opts, opts or {})

  vim.validate({
    enable_indent_char = { options.enable_indent_char, 'boolean' },
    indent_space_char = { options.indent_space_char, 'string' },
    indent_tab_char = { options.indent_tab_char, 'string' },
    default_space_indentation = { options.default_space_indentation, 'number' },
    exclude_filetypes = { options.exclude_filetypes, 'table' },
  })

  if options.enable_indent_char  == true then
    vim.opt.listchars:append({ tab = options.indent_tab_char..' ' })
    vim.opt.listchars:append({ leadmultispace = options.indent_space_char..' ' })
  end

  vim.api.nvim_create_autocmd('BufReadPost', {
    pattern = '*',
    callback = function()
      local should_indent_char = options.enable_indent_char == true
        and not vim.tbl_contains(options.exclude_filetypes, vim.bo.filetype)
      local lines = vim.api.nvim_buf_get_lines(0, 0, 100, false)
      local tab = '\t'

      -- check if there are indented lines
      -- and set listchars accordingly
      for lnum, line in ipairs(lines) do
        local first_char = line:sub(1, 1)
        if first_char == ' ' or first_char == tab then
          if first_char == tab then
            -- do not use spaces in this buffer
            vim.bo.expandtab = false
            return
          end
          local indent_level = vim.fn.indent(lnum)
          if indent_level == 4 then
            vim.bo.expandtab = true
            vim.bo.shiftwidth = indent_level
            vim.bo.tabstop = indent_level
            if should_indent_char then
              update_listchars_for_spaces(indent_level, options.indent_space_char)
            end
            return
          elseif indent_level == 2 then
            vim.bo.expandtab = true
            vim.bo.shiftwidth = indent_level
            vim.bo.tabstop = indent_level
            if should_indent_char then
              update_listchars_for_spaces(indent_level, options.indent_space_char)
            end
            return
          end
        end
      end

      if should_indent_char then
        update_listchars_for_spaces(options.default_space_indentation, options.indent_space_char)
      end
    end
  })
end

return M

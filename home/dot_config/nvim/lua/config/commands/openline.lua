-- OpenLine command - opens CSV first column as file path and launches storm
vim.api.nvim_create_user_command('OpenLine', function()
  local line = vim.fn.getline('.')

  -- Extract first column from CSV (handle quoted fields)
  local first_column = line:match('^"?([^",]*)"?')
  if not first_column or first_column == '' then
    print('No valid path found in first column')
    return
  end

  local dir = vim.fn.fnamemodify(first_column, ':p:h')
  local cmd = string.format('open %s && tmux new-window -c %s "storm"',
    vim.fn.shellescape(first_column),
    vim.fn.shellescape(dir))
  vim.fn.system(cmd)
end, {})
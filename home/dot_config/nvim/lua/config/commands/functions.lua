-- Custom functions and commands ported from .vimrc

-- Function to convert and sort all lines to comma-separated list
local function convert_and_sort_all_to_comma_separated_list()
  -- Sort all lines in the file
  vim.cmd('%sort u')
  
  -- Yank all lines in the file
  vim.cmd('%y')
  
  -- Get the yanked lines into a list
  local lines = vim.split(vim.fn.getreg('"'), '\n')
  
  -- Convert the sorted lines to a comma-separated list
  local comma_separated = table.concat(lines, ', ')
  
  -- Go to the end of the file and insert a blank line
  vim.cmd('normal! Go')
  
  -- Insert the comma-separated list on a new line
  vim.fn.append(vim.fn.line('.'), comma_separated)
  
  -- Move the cursor to the newly inserted line
  vim.cmd('normal! G')
  
  -- Copy the comma-separated list to the clipboard (for macOS)
  vim.fn.system('echo ' .. vim.fn.shellescape(comma_separated) .. ' | pbcopy')
  
  -- Save the file after copying to the clipboard
  vim.cmd('write')
end

-- Function to convert and sort all lines to space-separated Twitter tags
local function convert_and_sort_all_to_space_separated_twitter_tags()
  -- Sort all lines in the file
  vim.cmd('%sort u')
  
  -- Yank all lines in the file  
  vim.cmd('%y')
  
  -- Get the yanked lines into a list
  local lines = vim.split(vim.fn.getreg('"'), '\n')
  
  -- Function to camel-case each phrase
  local function camel_case_phrase(phrase)
    local words = vim.split(phrase, '%s+')
    if #words == 0 then return '#' end
    
    local result = '#' .. string.lower(words[1])
    for i = 2, #words do
      if #words[i] > 0 then
        result = result .. string.upper(string.sub(words[i], 1, 1)) .. string.lower(string.sub(words[i], 2))
      end
    end
    return result
  end
  
  -- Apply camel-case transformation and prefix with '#'
  local twitter_tags = {}
  for _, line in ipairs(lines) do
    table.insert(twitter_tags, camel_case_phrase(line))
  end
  
  -- Convert the sorted lines to a space-separated list
  local space_separated = table.concat(twitter_tags, ' ')
  
  -- Go to the end of the file and insert a blank line
  vim.cmd('normal! Go')
  
  -- Insert the space-separated list on a new line
  vim.fn.append(vim.fn.line('.'), space_separated)
  
  -- Move the cursor to the newly inserted line
  vim.cmd('normal! G')
  
  -- Copy the space-separated list to the clipboard (for macOS)
  vim.fn.system('echo ' .. vim.fn.shellescape(space_separated) .. ' | pbcopy')
  
  -- Save the file after copying to the clipboard
  vim.cmd('write')
end

-- Create user commands
vim.api.nvim_create_user_command('ClSort', convert_and_sort_all_to_comma_separated_list, {})
vim.api.nvim_create_user_command('ClSortTags', convert_and_sort_all_to_space_separated_twitter_tags, {})
-- init.lua
local Lightbeam = {}

-- Store active connections
Lightbeam.connections = {}

function Lightbeam.setup(opts)
  -- Set up commands
  vim.api.nvim_create_user_command('LightBeamStart', function()
    require('lightbeam.server').start_server()
  end, {})

  vim.api.nvim_create_user_command('LightBeamJoin', function()
    vim.ui.input({prompt = "Enter invitation code: "}, function(code)
      if code then
        require('lightbeam.server').join_server(code)
      end
    end)
  end, {})

  vim.api.nvim_create_user_command('LightBeamStop', function()
    require('lightbeam.server').stop_server()
  end, {})
end

return Lightbeam

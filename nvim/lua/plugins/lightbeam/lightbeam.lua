-- server.lua
local Lightbeam = {}

local ws = require('websocket')

function Lightbeam.start_server()
  -- Start the Go server process
  local job_id = vim.fn.jobstart({'lightbeam'}, {
    on_stdout = function(_, data)
      for _, line in ipairs(data) do
        if line:match("New invitation:") then
          local code = line:match("New invitation: (.+)")
          vim.notify("Server started! Invitation code: " .. code)
          -- Connect to the server as host
          Lightbeam.connect_to_server("ws://localhost:53067/", code, true)
        end
      end
    end,
    on_stderr = function(_, data)
      vim.notify("Server error: " .. vim.inspect(data), vim.log.levels.ERROR)
    end
  })

  if job_id <= 0 then
    vim.notify("Failed to start server", vim.log.levels.ERROR)
    return
  end

  require('lightbeam').connections.server_job = job_id
end

function Lightbeam.join_server(invitation_code)
  Lightbeam.connect_to_server("ws://localhost:53067/ws", invitation_code, false)
end

function Lightbeam.connect_to_server(url, code, is_host)
  local sock = ws.new({
    url = url .. (is_host and "" or "?invitation=" .. code),
    headers = {
      ["Sec-WebSocket-Protocol"] = is_host and "lightbeam-init" or "lightbeam"
    }
  })

  sock:on_message(function(msg)
    local data = vim.fn.json_decode(msg)
    Lightbeam.update_cursors(data)
  end)

  sock:on_error(function(err)
    vim.notify("WebSocket error: " .. err, vim.log.levels.ERROR)
  end)

  sock:connect()

  -- Store connection
  require('lightbeam').connections.socket = sock
end

function Lightbeam.update_cursors(cursor_data)
  -- Clear existing cursor highlights
  vim.cmd('sign unplace * group=lightbeam')
  -- Update cursor positions for each participant
  for id, cursor in pairs(cursor_data) do
    -- Create highlight group for participant color if it doesn't exist
    vim.cmd(string.format(
      'highlight LightBeamCursor_%s guibg=%s guifg=black',
      id:sub(1,8),
      cursor.color or "#729fcf"
    ))

    -- Place sign at cursor position
    vim.fn.sign_define('lightbeam_' .. id:sub(1,8), {
      text = "▶",
      texthl = 'LightBeamCursor_' .. id:sub(1,8)
    })
    vim.fn.sign_place(
      0,
      'lightbeam',
      'lightbeam_' .. id:sub(1,8),
      vim.fn.bufname(),
      {
        lnum = cursor.line + 1,
        priority = 10
      }
    )
  end
end

function Lightbeam.stop_server()
  local connections = require('lightbeam').connections
  if connections.socket then
    connections.socket:close()
    connections.socket = nil
  end

  if connections.server_job then
    vim.fn.jobstop(connections.server_job)
    connections.server_job = nil
  end

  vim.cmd('sign unplace * group=lightbeam')
  vim.notify("LightBeam stopped")
end

-- Send cursor updates when cursor moves
vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
  callback = function()
    local sock = require('lightbeam').connections.socket
    if sock then
      local pos = vim.api.nvim_win_get_cursor(0)
      local cursor_data = {
        file = vim.fn.expand('%:p'),
        line = pos[1] - 1,
        column = pos[2]
      }
      sock:send(vim.fn.json_encode(cursor_data))
    end
  end
})

return Lightbeam


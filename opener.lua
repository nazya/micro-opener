VERSION = "0.1.0"

local micro    = import("micro")
local config   = import("micro/config")
local buffer   = import("micro/buffer")
local shell    = import("micro/shell")
local filepath = import("path/filepath")

-- read options once
local cmd   = config.GetGlobalOption("openercmd")   or ""
local args  = config.GetGlobalOption("openerargs")  or ""
local mode  = config.GetGlobalOption("openermode")  or "thispane"
local path  = config.GetGlobalOption("openerpath")  or "relative"
local multi = config.GetGlobalOption("openermulti") or "newtab"

function opener(bp)
  if cmd == "" then
    micro.InfoBar():Message("opener: no 'openercmd' configured")
    return
  end

  -- resolve path if it's "relative"
  if (path == "relative" or path == "") and bp and bp.buf and bp.buf.Path and bp.buf.Path ~= "" then
    path = filepath.Dir(bp.buf.Path)
  end

  -- build cmd directly
  if args ~= "" then
    cmd = cmd .. " " .. args
  end
  if path ~= "" then
    cmd = cmd .. " " .. path
  end

  local output, err = shell.RunInteractiveShell(cmd, false, true)
  if err == nil then openerOutput(output, {bp}) end
end

function openerOutput(output, argsTbl)
  local bp = argsTbl[1]
  if not output or output == "" then return end

  local currentMode = mode
  for file in output:gmatch("[^\r\n]+") do
    if currentMode == "newtab" then
      bp:NewTabCmd({file})
    else
      local buf, _ = buffer.NewBufferFromFile(file)
      if currentMode == "vsplit" then
        bp:VSplitIndex(buf, true)
      elseif currentMode == "hsplit" then
        bp:HSplitIndex(buf, true)
      else
        bp:OpenBuffer(buf)
      end
    end
    currentMode = multi -- subsequent files
  end
end

function init()
  config.MakeCommand("opener", opener, config.NoComplete)
end

#!/usr/bin/env lua

local DIR = "."
local WAVES_DIR = ".waves"
local PYTHON = "python3"

os.execute("mkdir -p " .. WAVES_DIR)

print("👀 Watching Python saves, deletes, renames…")
print("📦 Waves → " .. WAVES_DIR)

-- Track rename cookies
local rename_from = {}

local watch_cmd = string.format(
  "inotifywait -m -e close_write -e delete -e delete_self -e moved_from -e moved_to " ..
  "--format '%%e %%c %%f' %s",
  DIR
)

local watcher = io.popen(watch_cmd)

for line in watcher:lines() do
  local events, cookie, filename = line:match("^(.-) (%d+) (.+)$")

  if not filename or not filename:match("%.py$") then
    goto continue
  end

  local base = filename:gsub("%.py$", "")
  local wave = WAVES_DIR .. "/" .. base

  -- 🗑️ DELETE
  if events:match("DELETE") or events:match("DELETE_SELF") then
    os.execute("rm -f " .. wave)
    print("🗑️  Removed wave: " .. wave)

    -- ✏️ SAVE → RUN
  elseif events:match("CLOSE_WRITE") then
    os.execute("clear")
    print("🛠️  Compiling " .. filename)
    print(string.rep("─", 30))
    --print("✅ Build success")
    --print(string.rep("─", 30))

    local cmd = string.format("%s %s", PYTHON, filename)
    local code = os.execute(cmd)

    if not (code == true or code == 0) then
      print("\n❌ (Correction) Build failed")
      print(string.rep("─", 30))
    end

    -- 🔄 RENAME FROM
  elseif events:match("MOVED_FROM") then
    rename_from[cookie] = filename

    -- 🔁 RENAME TO
  elseif events:match("MOVED_TO") then
    local old = rename_from[cookie]
    if old then
      local old_wave = WAVES_DIR .. "/" .. old:gsub("%.py$", "")
      local new_wave = WAVES_DIR .. "/" .. filename:gsub("%.py$", "")

      if os.execute("[ -f " .. old_wave .. " ]") then
        os.execute("mv " .. old_wave .. " " .. new_wave)
        print("🔁 Renamed wave: " .. old_wave .. " → " .. new_wave)
      end

      rename_from[cookie] = nil
    end
  end

  ::continue::
end

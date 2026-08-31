#!/usr/bin/env lua

local DIR = "."
local RUNTIME_DIR = ".bun"
local RUNTIME = "bun"

os.execute("mkdir -p " .. RUNTIME_DIR)

print("👀 Watching JavaScript saves, deletes, renames…")
print("📦 Runtime → " .. RUNTIME_DIR)

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

  if not filename or not filename:match("%.js$") then
    goto continue
  end

  local base = filename:gsub("%.js$", "")
  local wave = RUNTIME_DIR .. "/" .. base

  -- 🗑️ DELETE
  if events:match("DELETE") or events:match("DELETE_SELF") then
    os.execute("rm -f " .. wave)
    print("🗑️  Removed runtime artifact: " .. wave)

    -- ✏️ SAVE → RUN
  elseif events:match("CLOSE_WRITE") then
    os.execute("clear")
    print("🛠️  Compiling " .. filename)
    print(string.rep("─", 30))

    local cmd = string.format("%s run %s", RUNTIME, filename)
    local pipe = io.popen(cmd .. " 2>&1")
    local output = pipe:read("*a")
    local ok, _, code = pipe:close()

    if ok and code == 0 then
      print("✅ Build success")
      print(string.rep("─", 30))
      if output ~= "" then
        io.write(output)
      end
    else
      print("❌ Build failed")
      print(string.rep("─", 30))
      print(output)
    end

    -- 🔄 RENAME FROM
  elseif events:match("MOVED_FROM") then
    rename_from[cookie] = filename

    -- 🔁 RENAME TO
  elseif events:match("MOVED_TO") then
    local old = rename_from[cookie]
    if old then
      local old_wave = RUNTIME_DIR .. "/" .. old:gsub("%.js$", "")
      local new_wave = RUNTIME_DIR .. "/" .. filename:gsub("%.js$", "")

      if os.execute("[ -f " .. old_wave .. " ]") then
        os.execute("mv " .. old_wave .. " " .. new_wave)
        print("🔁 Renamed runtime artifact: " .. old_wave .. " → " .. new_wave)
      end

      rename_from[cookie] = nil
    end
  end

  ::continue::
end

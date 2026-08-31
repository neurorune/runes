#!/usr/bin/env lua

local DIR = "."
local ELIXIR = "elixir"

print("👀 Watching Elixir saves, deletes, renames…")
print("🚀 Runs with `elixir` → output shows on screen")

local watch_cmd = string.format(
  "inotifywait -m -e close_write -e delete -e delete_self -e moved_from -e moved_to " ..
  "--format '%%e %%c %%f' %s",
  DIR
)

local watcher = io.popen(watch_cmd)

for line in watcher:lines() do
  local events, cookie, filename = line:match("^(.-) (%d+) (.+)$")

  if not filename or not filename:match("%.exs$") then
    goto continue
  end

  -- 🗑️ DELETE
  if events:match("DELETE") or events:match("DELETE_SELF") then
    print("🗑️  Removed: " .. filename)

    -- ✏️ SAVE → RUN
  elseif events:match("CLOSE_WRITE") then
    os.execute("clear")
    print("🛠️  Running " .. filename)
    print(string.rep("─", 30))

    local code = os.execute(string.format("%s %s", ELIXIR, filename))

    if not (code == true or code == 0) then
      print(string.rep("─", 30))
      print("❌ Failed")
    end
  end

  ::continue::
end

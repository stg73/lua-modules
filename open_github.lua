local M = {}

local w = require("open_webpage")
local r = require("regex")

function M.open_tbl(tbl)
    if r.is("/x+")(tbl.commit) then -- コミットIDであれば
        w.open_webpage("https://github.com/" .. tbl.repo .. "/raw/" .. tbl.commit .. "/" .. tbl.file)
    else
        w.open_webpage("https://github.com/" .. tbl.repo .. "/raw/refs/heads/" .. tbl.commit .. "/" .. tbl.file)
    end
end

function M.open(repo) return function(commit) return function(file)
    if r.is("/x+")(commit) then -- コミットIDであれば
        w.open_webpage("https://github.com/" .. repo .. "/raw/" .. commit .. "/" .. file)
    else
        w.open_webpage("https://github.com/" .. repo .. "/raw/refs/heads/" .. commit .. "/" .. file)
    end
end end end

return M

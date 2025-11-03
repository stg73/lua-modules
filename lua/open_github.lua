local M = {}

local w = require("open_webpage")
local r = require("regex")

local function hoge(str)
    if r.has("^\\c")(str) then
        return r.remove("^\\.")(str)
    elseif r.has("^\\b")(str) then
        return "refs/heads/" .. r.remove("^\\.")(str)
    elseif r.has("^\\t")(str) then
        return "refs/tags/" .. r.remove("^\\.")(str)
    else
        return "HEAD/" .. str
    end
end

M.get_url = {}

function M.get_url.tbl(tbl)
    return "github.com/" .. tbl.repo .. "/raw/" .. hoge(tbl.commit) .. "/" .. tbl.file
end

function M.get_url.url(str)
    local repo = r.match(".{-}//.{-}//")(str)
    local x = r.remove("^.{-}//.{-}//")(str)
    return "github.com/" .. repo .. "raw/" .. hoge(x)
end

function M.open(str_or_tbl)
    if type(str_or_tbl) == "table" then
        w.open(M.get_url.tbl(str_or_tbl))
    else
        w.open(M.get_url.url(str_or_tbl))
    end
end

return M

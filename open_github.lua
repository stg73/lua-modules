local M = {}

local w = require("open_webpage")
local r = require("regex")

local function hoge(str)
    if r.is("/x+")(str) then
        return str
    else
        return "refs/heads/" .. str
    end
end

M.get_url = {}

function M.get_url.tbl(tbl)
    return "github.com/" .. tbl.repo .. "/raw/" .. hoge(tbl.commit) .. "/" .. tbl.file
end

function M.get_url.str(repo) return function(commit) return function(file)
    return "github.com/" .. repo .. "/raw/" .. hoge(commit) .. "/" .. file
end end end

function M.get_url.url(str)
    local repo = r.gsub("/")("/.")(r.match("[^//]+")(str))
    local commit = r.gsub("/")("/.")(r.match("//@<=[^//]+")(str))
    local file = r.remove(".{-}//.{-}//")(str)
    return M.get_url.str(repo)(commit)(file)
end

function M.open(str_or_tbl)
    if type(str_or_tbl) == "table" then
        w.open(M.get_url.tbl(str_or_tbl))
    else
        return function(commit) return function(file)
            w.open(M.get_url.str(str_or_tbl)(commit)(file))
        end end
    end
end

function M.open_url(str)
    w.open(M.get_url.url(str))
end

return M

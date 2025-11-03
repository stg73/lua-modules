local M = {}

local r = require("regex")
local t = require("tbl")

function M.get_string(mode,lhs)
    local map_result = vim.fn.execute(mode .. "map " .. lhs) -- map コマンドの結果
    local map_line = r.match("\n.  /V" .. lhs .. " /v[^\n]+")(map_result) -- 部分一致するマッピングも表示されるので完全一致するものだけ取得
    return r.remove("^\n.{3}/V" .. lhs .. "/v.{3}")(map_line) -- マッピングの部分を取得
end

function M.get(mode,lhs)
    local mapping = t.match(function(t) return t.lhs == lhs end)(vim.api.nvim_get_keymap(mode))
    return mapping.rhs or mapping.callback
end

return M

local M = {}

local r = require("regex")

function M.get(mode,lhs)
    local map_result = vim.fn.execute(mode .. "map " .. lhs) -- map コマンドの結果
    local map_line = r.match("\n.  /V" .. lhs .. " /v[^\n]+")(map_result) -- 部分一致するマッピングも表示されるので完全一致するものだけ取得
    return r.remove("^\n.{3}/V" .. lhs .. "/v.{3}")(map_line) -- マッピングの部分を取得
end

return M

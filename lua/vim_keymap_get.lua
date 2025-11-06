local M = {}

local r = require("regex")
local t = require("tbl")

function M.get_string(mode,lhs)
    local map_result = vim.fn.execute(mode .. "map " .. lhs) -- map コマンドの結果
    local map_line = r.match("\n.  /V" .. lhs .. " /v[^\n]+")(map_result) -- 部分一致するマッピングも表示されるので完全一致するものだけ取得
    return r.remove("^\n.{3}/V" .. lhs .. "/v.{3}")(map_line) -- マッピングの部分を取得
end

function M.get(mode,lhs,opts)
    -- 引数の既定値
    local opts = opts or {}

    local mapping = t.match(function(t) return t.lhs == lhs end)(vim.api.nvim_get_keymap(mode))
    if mapping then
        local rhs = mapping.rhs or mapping.callback
        if opts.remap and (mapping.noremap == 0 or r.has("^/V/c<plug>")(rhs)) then -- remap オプションが指定されており実際にリマップされている場合
            return M.get(mode,rhs,opts)
        end
        return rhs
    else
        return nil
    end
end

return M

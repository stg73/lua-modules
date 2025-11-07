local M = {}

local r = require("regex")
local t = require("tbl")

function M.get(mode,lhs,opts)
    -- 引数の既定値
    local opts = opts or {}

    local mapping = t.match(function(t) return t.lhs == lhs end)(vim.api.nvim_get_keymap(mode))

    if mapping == nil then
        return nil
    end

    local rhs = mapping.rhs or mapping.callback

    if opts.remap and (mapping.noremap == 0 or r.has("^/V/c<plug>")(mapping.rhs or "")) then -- remap オプションが指定されており実際にリマップされている場合
        return M.get(mode,rhs,opts)
    end

    if opts.expr and mapping.expr == 0 then
        return nil
    end

    return rhs
end

return M

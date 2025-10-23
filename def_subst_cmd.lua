local M = {}

local function g() -- グローバルにするフラグを返す
    return vim.o.gdefault and "" or "g"
end

-- 置換する関数
local function su(opts,tbl_tbl,bool)
    local function s_single(tbl) -- 一文字置換する
        vim.cmd("silent " .. opts.line1 .. "," .. opts.line2 .. [[substitute/\V]] .. vim.fn.escape(tbl[bool and 1 or 2],[[/\]]) .. "/" .. vim.fn.escape(tbl[bool and 2 or 1],[[/\]]) .. "/e" .. g())
    end

    for i in pairs(tbl_tbl) do
        s_single(tbl_tbl[i])
    end
end

-- 楽に定義するための関数
function M.def_subst_cmd(name,tbl,bool)
    vim.api.nvim_create_user_command(name,function(opts)
        local x = vim.fn.getreg("/")
        su(opts,tbl,bool)
        vim.fn.setreg("/",x)
        vim.cmd.nohlsearch()
    end,{range = true,bar = true})
end

return M

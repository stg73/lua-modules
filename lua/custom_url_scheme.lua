local M = {}

local regex = require("regex")
local t = require("tbl")

function M.init()
    vim.api.nvim_create_autocmd("BufReadCmd",{
        group = vim.api.nvim_create_augroup('custom_url_scheme',{}),
        pattern = "*://*",
        callback = function(opts)
            local scheme,rest = string.match(opts.match,"(.+)://(.+)")
            if M.schemes[scheme] then -- スキームが定義されていたら
                vim.cmd.buffer("#") vim.cmd.bwipeout(opts.buf) -- ウィンドウを消さずにバッファを削除
                M.schemes[scheme](rest)
            end
        end
    })
end

M.schemes = {} -- スキームと関数の対応を記録する
local function add(scheme) return function(fn)
    M.schemes[scheme] = fn
end end

M.add = t.foreach(add)

return M

local M = {}

local group = vim.api.nvim_create_augroup('create_urlscheme',{})

function M.create(scheme,open)
    vim.api.nvim_create_autocmd("BufReadCmd",{
        group = group,
        pattern = scheme .. "://*",
        callback = function(opts)
            vim.cmd.buffer("#") vim.cmd.bwipeout(opts.buf) -- ウィンドウを消さないようにバッファを削除
            open(regex.remove("^.{-1,}:////")(opts.match))
        end
    })
end

return M

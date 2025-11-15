local M = {}

local str = require("string_utils")

function M.access(url)
    local temp = vim.fn.tempname()
    local job = vim.system({
        "curl",
        "-L",
        url,
        "-o",
        temp
    },{}):wait()
    if job.code == 0 then
        vim.cmd.edit(temp)
        vim.b.URL = url -- URLが後から分かるように
    else
        local stderr = str.remove.hoge(str.remove.ansi_escape_code(job.stderr)) -- 変な改行とエスケープシーケンスを除去
        vim.fn.feedkeys(":","nx") -- エラー出力の上部に前のメッセージが表示されぬよう
        error(stderr)
    end
end

function M.open(url)
    vim.notify("accessing",vim.log.levels.INFO)
    M.access(url)
    vim.fn.feedkeys(":","nx") -- メーセージをクリア
    if vim.o.filetype == "" then
        vim.bo.filetype = vim.filetype.match({ filename = str.get.path_of_url(url) or "", buf = 0 }) or "html"
    end
end

return M

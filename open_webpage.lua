local M = {}

local str = require("string_utils")

function M.access_webpage(url)
    local temp = vim.fn.tempname()
    local job = vim.system({
        "pwsh.exe", -- 問題 カレントディレクトリに"pwsh.exe"があるとそちらを実行してしまう
        "-noprofile",
        "-command",
        "invoke-webrequest",
        url,
        "-outfile",
        temp
    },{}):wait()
    if job.code == 0 then
        vim.cmd.edit(temp)
        vim.b.URL = url -- URLが後から分かるように
    else
        local stderr = str.remove.hoge(str.remove.ansi_escape_code(job.stderr)) -- 変な改行とエスケープシーケンスを除去
        local err_msg = require("regex").gsub("pwsh")("^Invoke-WebRequest")(stderr)
        vim.fn.feedkeys(":","nx") -- エラー出力の上部に前のメッセージが表示されぬよう
        error(err_msg)
    end
end

function M.open_webpage(url)
    vim.notify("accessing",vim.log.levels.INFO)
    M.access_webpage(url)
    vim.fn.feedkeys(":","nx") -- メーセージをクリア
    vim.bo.filetype = vim.filetype.match({ filename = str.get.path_of_url(url) or "", buf = 0 }) or "html"
end

return M

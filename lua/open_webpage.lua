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
        vim.fn.feedkeys(":","nx") -- エラー出力の上部に前のメッセージが表示されぬよう
        error("\n> curl -L " .. url .. " -o " .. temp .. "\n" .. job.stderr)
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

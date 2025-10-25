local M = {}

-- オプションの違いを吸収 -- substituteコマンドをグローバルにする
local function g()
    return vim.o.gdefault and "" or "g"
end

function M.sort(opts) -- "skkdic-expr2"のラッパー
    local current_search = vim.fn.getreg('/')
    vim.cmd([[$?;; okuri-ari entries.?;$!skkdic-expr2]]) -- ファイル上部のコメントを削除しないためにrangeが複雑
    vim.fn.setreg('/',current_search)
    vim.cmd.nohlsearch()
end

function M.annotate(opts)
    if vim.b.skk_bunnrui then
        local current_search = vim.fn.getreg('/')
        vim.cmd(opts.line1 .. ',' .. opts.line2 .. [[substitute/\v(\/[^/;]*\S)@<=\/@=/;[]] .. vim.b.skk_bunnrui .. ']/e' .. g())
        vim.fn.setreg('/',current_search)
        vim.cmd.nohlsearch()
    end
end

-- 上より高性能だが速度のことは分からない
function M.aNnotate(opts)
    if vim.b.skk_bunnrui then
        local current_search = vim.fn.getreg('/')
        local s = opts.line1 .. ',' .. opts.line2 .. "substitute/\\v"
        local e = "/e" .. g()
        vim.cmd(s .. [[(\/[^;]+)@<=\/@=/;]] .. e .. " | " .. s .. [[;@<=(\[]] .. vim.b.skk_bunnrui .. [[\])@!/\[]] .. vim.b.skk_bunnrui .. "\\]" .. e)
        vim.fn.setreg('/',current_search)
        vim.cmd.nohlsearch()
    end
end

function M.count_annotation_errors(opts)
    local current_search = vim.fn.getreg('/')
    vim.cmd.skkSearchAnnotationErrors()
    vim.cmd(opts.line1 .. "," .. opts.line2 .. [[substitute///ne]] .. g())
    vim.fn.setreg('/',current_search)
    vim.cmd.nohlsearch()
end

function M.search_annotation_errors(opts)
    if vim.b.skk_bunnrui then
        vim.fn.setreg('/',[[\v\/@<=([^/]+;\[]] .. vim.b.skk_bunnrui .. [[\])@![^/]+]])
    end
end

function M.search_midasi_kouho(opts)
    vim.fn.setreg('/',[[\v(^(;; )@!.+ .*\/)@<=[^/]+]])
end

return M

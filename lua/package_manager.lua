local M = {}

local s = require("string_utils")
local r = require("regex")
local t = require("tbl")

-- パッケージを管理するディレクトリを決める
function M.directory(d)
    local dir = r.remove("//$")(d)
    local available_packages = dir .. "/available_packages.json"

    local D = {}

    local f = io.open(available_packages,"r")
    D.available_packages = vim.json.decode(f:read("a"))
    f:close()

    function D.is_installed(pkg)
        local function same_pkg(pkg1) return function(pkg2)
            return pkg1.repo == pkg2.repo
        end end
        return t.match(same_pkg(pkg))(vim.tbl_values(D.available_packages)) and true or false
    end

    local on_exit = vim.schedule_wrap(function(job)
        if job.code ~= 0 then
            error(str.remove.trailing_space(job.stderr))
        end
    end)

    function D.install(name) return function(pkg)
        if pkg.requires then
            D.install()(pkg.requires)
        end

        local pkg = (type(pkg) == "string") and { repo = pkg } or pkg
        pkg.repo = not r.has("^.+:////")(pkg.repo) and "https://github.com/" .. pkg.repo or pkg.repo -- スキームが無ければgithubを使う
        local name = (type(name) == "string") and name or vim.fn.fnamemodify(pkg.repo,":t")

        if D.is_installed(pkg) then
            return
        end

        local function hoge(str1,str2)
            if str1 and str2 then
                return str1,str2
            else
                return nil
            end
        end

        vim.system({
            "git","-C",dir,
            "clone",pkg.repo,name,
            "--depth","1","--recursive",
            hoge("--branch",pkg.branch or pkg.tag),
        },on_exit)

        D.available_packages = vim.tbl_extend("force",D.available_packages,{ [name] = pkg }) -- パッケージの情報を更新
        local f = io.open(available_packages,"w")
        f:write(vim.json.encode(D.available_packages))
        f:close()

        return name
    end end

    function D.uninstall(name)
        local pkg_path = dir .. "/" .. name
        if vim.fn.isdirectory(pkg_path) ~= 0 then -- パッケージのディレクトリが存在したら
            vim.system({ "pwsh","-command","remove-item","-recurse","-force",pkg_path },on_exit)
        end

        D.available_packages[name] = nil
        local f = io.open(available_packages,"w")
        f:write(vim.json.encode(D.available_packages))
        f:close()

        return name
    end

    D.install_table = t.foreach(D.install)

    function D.update(name)
        vim.system({"git","-C",dir .. "/" .. name,"pull","--rebase"},on_exit)

        return name
    end

    -- runtimepath に追加

    function D.add(name)
        vim.opt.runtimepath:append(dir .. "/" .. name)
    end

    function D.add_opt(opt) return function(name)
        local add = function() D.add(name) end
        local function map_add(mode,map)
            vim.keymap.set(mode,map,function()
                add()
                vim.fn.feedkeys(map,"n")
                vim.keymap.del(mode,map)
            end)
        end

        if opt.event then
            vim.api.nvim_create_autocmd(opt.event,{ callback = add })
        end
        if opt.filetype then
            vim.api.nvim_create_autocmd("FileType",{
                pattern = opt.filetype,
                callback = add,
            })
        end
        if opt.nmap then
            map_add("n",opt.nmap)
        end
        if opt.tmap then
            map_add("n",opt.nmap)
        end
        if opt.vmap then
            map_add("n",opt.nmap)
        end
        if opt.imap then
            map_add("n",opt.nmap)
        end
        if opt.omap then
            map_add("n",opt.nmap)
        end
        if opt.cmap then
            map_add("n",opt.nmap)
        end
    end end

    return D
end

return M

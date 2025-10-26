local M = {}

-- 主に character_tableを使って文字列置換をするため
-- テーブルの引数に対応する部分がテーブルの場合は扱いが少し異なる
function M.fn(tbl) return function(x)
    local function f(i)
        local t = tbl[i]
        if t == nil then
            return nil
        elseif type(t[1]) == "table" then
            if M.equal_to_any_element(t[1])(x) then
                return t[2]
            else
                return f(i + 1)
            end
        elseif t[1] == x then
            return t[2]
        else
            return f(i + 1)
        end
    end

    return f(1)
end end

-- M.fnの逆
function M.fn_reverse(tbl) return function(x)
    local function f(i)
        local t = tbl[i]
        if t == nil then
            return nil
        elseif type(t[2]) == "table" then -- ほぼskk.hennkann.buf_reverseで使うための機能
            if M.equal_to_any_element(t[2])(x) then
                return t[1]
            else
                return f(i + 1)
            end
        elseif t[2] == x then
            return t[1]
        else
            return f(i + 1)
        end
    end

    return f(1)
end end

function M.filter(fn) return function(arg_tbl)
    local t = {}
    for i = 1, #arg_tbl do
        if fn(arg_tbl[i]) then
            table.insert(t,arg_tbl[i])
        end
    end

    return t
end end

-- pre(arg)であればfn(arg)を返す そうでなければnilを返す
function M.map_filter(fn) return function(pre) return function(arg)
    if pre(arg) then
        return fn(arg)
    else
        return nil
    end
end end end

-- テーブルの要素のうち最初に条件に合致したものに関数を適用する
-- 名前の由来 M.compose({ M.get(1), M.map(fn), M.filter(pre) })
function M.first_map_filter(fn) return function(pre) return function(tbl)
    local function f(i)
        local arg = tbl[i]
        if arg == nil then
            return nil
        elseif pre(arg) then
            return fn(arg)
        else
            return f(i + 1)
        end
    end

    return f(1)
end end end

function M.map(fn) return function(arg_tbl)
    local t = {}
    for i = 1, #arg_tbl do
        table.insert(t,fn(arg_tbl[i]))
    end

    return t
end end

-- M.mapの 関数と引数が逆
function M.map_reverse(fn_tbl) return function(arg)
    local t = {}
    for i = 1, #fn_tbl do
        table.insert(t,(fn_tbl[i])(arg))
    end

    return t
end end

-- シェルのパイプのように関数を繋げていく
function M.pipe(tbl)
    local function f(i,arg)
        if tbl[i] == nil then
            return arg
        end
        return f(i + 1,tbl[i](arg))
    end

    return f(2,tbl[1])
end

-- 関数合成
function M.compose(tbl)
    local function f(i,fn)
        if tbl[i] == nil then
            return fn
        else
            return f(i + 1,function(x) return fn(tbl[i](x)) end)
        end
    end

    return f(2,tbl[1])
end

-- テーブルからキーの値を取得する M.pipe({{"hoge","fuga"},M.get(1)}) == "hoge"
function M.get(key) return function(tbl)
    return tbl[key]
end end

function M.flip(fn) return function(x) return function(y)
    return fn(y)(x)
end end end

function M.fold(fn) return function(tbl)
    local function f(result,i)
        if tbl[i] == nil then
            return result
        else
            return f(fn(result,tbl[i]),i + 1)
        end
    end

    return f(tbl[1],2)
end end

-- 関数をカリー化
function M.curry2(fn)
    return function(x)
        return function(y)
            return fn(x,y)
        end
    end
end

function M.curry3(fn)
    return function(x)
        return function(y)
            return function(z)
                return fn(x,y,z)
            end
        end
    end
end

function M.curry4(fn)
    return function(x)
        return function(y)
            return function(z)
                return function(a)
                    return fn(x,y,z,a)
                end
            end
        end
    end
end

function M.equal_to_any_element(cond) return function(x)
    local function f(y) return y == x end
    return M.first_map_filter(f)(f)(cond)
end end

return M

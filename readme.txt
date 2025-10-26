neovim用のluaモジュール群

character_table.lua
    平仮名と片仮名、半角と全角、など文字の対応を集めたもの
    例えば {{"あ","ア"},{"い","イ"}} のようなもの

def_subst_cmd.lua
    character_tableを使って文字列を置換するコマンドを作る
    使い方の例
        local s = require("def_subst_cmd")
        local c = require("character_table")

        s.create("Katakana",c.Hiragana_Katakana)
        s.create_reverse("Hiragana",c.Hiragana_Katakana)

open_webpage.lua
    ウェブページをダウンロードしてneovimで閲覧する ファイルタイプをセットする
    powershellが必要
    使い方の例
        vim.api.nvim_create_autocmd('BufReadCmd',{
            pattern = {'https://*','http://*'},
            callback = function(opts)
                vim.cmd.buffer("#") vim.cmd.bwipeout(opts.buf) -- ウィンドウを消さないようにバッファを削除
                require("open_webpage").open_webpage(opts.match)
            end
        })


regex.lua
    vimの正規表現を使って文字列を操作する
    バックスラッシュの代わりにスラッシュを使う

romaji.lua
    ローマ字と仮名のパターンを提供する

skk_commands.lua
    SKKを編集するためのコマンド
    正確には "vim.api.nvim_create_user_command"の2番目の引数として与える関数を提供する
    使い方の例
        vim.api.nvim_create_user_command("SkkAnnotate",require("skk_commands").annotate,{bar = true,range = "%"})

skk.lua
    SKKを解析する
    構文解析したり バッファからSKKを読み込んで変換をしたりする

string_utils.lua
    文字列を操作するためのユーティリティ

tbl.lua
    テーブルという名前だが 雑多

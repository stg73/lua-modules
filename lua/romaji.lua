local M = {}

-- regex.gsub用のパターン
M.romaji = "nn|-|;|[bcdfghjkmnprstvwxyz]{0,3}[ieaou]" -- ローマ字として解釈できる文字列
M.romaji_rennzoku = "bb@=|cc@=|dd@=|ff@=|gg@=|hh@=|jj@=|kk@=|mm@=|pp@=|rr@=|ss@=|tt@=|vv@=|ww@=|xx@=|yy@=|zz@=|" .. M.romaji -- 上に("tta" -> "った")系を追加したもの
M.kana = "っ|[あ-んゔ][ぇぁぃぅぉゃゅょ]?" -- 仮名として解釈できる文字列 促音は";"のみ対応

return M

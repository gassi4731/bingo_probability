# 状態
# 0...初期値・何もアクションがない
# 1...穴が空いた状態
# 2...問題に間違い穴が開かなかった状態

# 環境変数
@cardNum = 9 # ビンゴの枠の量
@cardNumOne = 3 # ビンゴの1辺の数
@drawnNum = 25 # 抽選される数
@exeNum = 100000 # 実行回数

# メイン
def main()
  # 結果を入れる配列
  result = Array.new(@drawnNum+1){ |x| x = 0 }
  for i in 0...@exeNum do
    result[cycle()] += 1
  end

  # 結果を書き込む
  File.open("result.csv", mode="w") do |f|
    result.each_with_index do |r, index|
      f.write(index, ",", r/@exeNum.to_f, ",", r, "\n")
    end
  end
end

# 1サイクル
def cycle()
  # 初期化
  # ビンゴの枠をつくる & カードにランダムに数字を入れていく
  @card = Array.new(@cardNum){ |index| [index+1, 0] }
  # @card.shuffle!

  # 抽選順を作成
  @draw = Array.new(@drawnNum){ |index| index+1 }
  @draw.shuffle!

  for i in 0...@draw.length do
    for j in 0...@card.length do
      if @draw[i] == @card[j][0]

        # -----------------------------
        # 3分の1の確率で穴があくようにする
        # -----------------------------
        if rand(1..3) == 1
          @card[j][1] = 1 # 数字があたったことを記録
        else
          @card[j][1] = 2 # 数字が当たらなかった
        end
        if judge()
          return i+1
        end
      end
    end
  end

  return 0
end

# ビンゴかどうか判断する
def judge()
  for i in 0..@cardNumOne-1 do
    # タテ
    shot_cnt_in_line = 0
    for j in 0..@cardNumOne-1 do
      if @card[@cardNumOne * i + j][1] == 1
        shot_cnt_in_line += 1
      end
    end
    if shot_cnt_in_line == @cardNumOne
      break
      return true
    end

    # ヨコ
    shot_cnt_in_line = 0
    for j in 0..@cardNumOne-1 do
      if @card[i + @cardNumOne * j][1] == 1
        shot_cnt_in_line += 1
      end
    end
    if shot_cnt_in_line == @cardNumOne
      break
      return true
    end
  end

  # ナナメ
  shot_cnt_in_line = 0
  for i in 0..@cardNumOne-1 do
    if @card[@cardNumOne+1 * i][1] == 1
      shot_cnt_in_line += 1
    end
  end
  if shot_cnt_in_line == @cardNumOne
    return true
  end

  shot_cnt_in_line = 0
  for i in 0..@cardNumOne-1 do
    if @card[@cardNumOne-1 * i + @cardNumOne-1][1] == 1
      shot_cnt_in_line += 1
    end
  end
  if shot_cnt_in_line == @cardNumOne
    return true
  end

  return false
end

main()

# print @card
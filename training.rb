# このコードをコピペしてrubyファイルに貼り付け、そのファイルをirbでrequireして実行しましょう。

# 例

# irb
# require '/Users/shibatadaiki/work_shiba/full_stack/sample.rb'
# （↑のパスは、自動販売機ファイルが入っているパスを指定する）

# 初期設定（自動販売機インスタンスを作成して、vmという変数に代入する）
# vm = VendingMachine.new

# 作成した自動販売機に100円を入れる
# vm.slot_money (100)

# 作成した自動販売機に入れたお金がいくらかを確認する（表示する）
# vm.current_slot_money

# 作成した自動販売機に入れたお金を返してもらう
# vm.return_money

class Juice_choice

  private
  def choice
    juice_list
    puts "投入金額:#{@slot_money}円"
    for i in 0..2 do
      puts "#{i}: #{@juice.name[i]}:#{@juice.price[i]}円"
    end
    puts "3: やっぱり買わない"
    puts
    puts "数字を入力してください"

    choice_number = gets.chomp

    if choice_number != "0" && choice_number != "1" && choice_number != "2" && choice_number != "3"
      puts
      puts "0~3のみで入力してください。"
      puts
      return self.choice
    end
    @choice_juice = choice_number.to_i
  end

  def juice_list
    puts "投入金額と在庫から買えるのは以下の飲み物です"
    puts
    for i in 0..2 do
      if @slot_money >= @juice.price[i] && @juice.number[i] >= 1
        puts "#{@juice.name[i]}"
        puts
      # else
      #   puts "#{@juice.name[i]}は買えん"
      #   puts
      end
    end
  end
end

class Buy_sale < Juice_choice
  def buy_juice
    choice
    if @choice_juice == 3
      return puts "買わないんかい"
    elsif @slot_money >= @juice.price[@choice_juice] && @juice.number[@choice_juice] >= 1
      puts "#{@juice.name[@choice_juice]}が出てきた。"
      @juice.number[@choice_juice] -= 1
      total_sale(@choice_juice)
      return_money
    elsif @juice.number[@choice_juice] == 0
      puts '赤いばってん'
      buy_juice
    else
      puts
      puts ' ---------------------'
      puts '| お金がたりない（笑）|'
      puts ' ---------------------'
      puts
      self.buy_juice
    end
  end

  def total_sale(choice_juice)
    @slot_money -= @juice.price[@choice_juice]
    @sale += @juice.price[@choice_juice]
  end
end

class VendingMachine < Buy_sale
  # ステップ０　お金の投入と払い戻しの例コード
  # ステップ１　扱えないお金の例コード
  # include Buy
  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  MONEY = [10, 50, 100, 500, 1000].freeze
  attr_accessor :juice, :sale
  # （自動販売機に投入された金額をインスタンス変数の @slot_money に代入する）
  def initialize
    # 最初の自動販売機に入っている金額は0円
    @slot_money = 0
    @juice = Juice.new
    @sale = 0
  end

  # 投入金額の総計を取得できる。
  def current_slot_money
    # 自動販売機に入っているお金を表示する
    @slot_money
  end

  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  # 投入は複数回できる。
  def slot_money(money)
    # 想定外のもの（１円玉や５円玉。千円札以外のお札、そもそもお金じゃないもの（数字以外のもの）など）
    # が投入された場合は、投入金額に加算せず、それをそのまま釣り銭としてユーザに出力する。
    return false unless MONEY.include?(money)
    # 自動販売機にお金を入れる
    @slot_money += money
  end

  # 払い戻し操作を行うと、投入金額の総計を釣り銭として出力する。
  def return_money
    # 返すお金の金額を表示する
    puts @slot_money
    # 自動販売機に入っているお金を0円に戻す
    @slot_money = 0
  end
end

class Juice
  attr_accessor :name, :price, :number
  def initialize
    @name = ["コーラ", "レッドブル", "水"]
    @price = [120,200,100]
    @number = [5,5,5]
  end

  # def make
  #   @juice = Juice.new
  # end
end

vend = VendingMachine.new
6.times do
  vend.slot_money(100)
  vend.slot_money(50)
  vend.buy_juice
end

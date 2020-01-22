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
class User

  CHOICE_JUICE = ["コーラ", "レッドブル", "水", "キャンセル"].freeze

  def initialize(name: 'taro')
    @name = name
  end

  def juice_list(machine)
    puts "投入金額と在庫から買えるのは以下の飲み物です"
    for i in 0..2 do
      if machine.current_slot_money >= machine.juice.price[i] && machine.juice.stock[i] >= 1
        puts "#{machine.juice.juice_name[i]}"
      end
    end
  end

  def choice(machine)
    juice_list(machine)
    puts "投入金額:#{machine.current_slot_money}円"
    for i in 0..2 do
      puts "#{i}: #{machine.juice.juice_name[i]}:#{machine.juice.price[i]}円"
    end
    puts "3: キャンセル"
    puts "数字を入力してください"

    choice_number = Integer(gets.chomp) rescue nil

    if choice_number == nil || CHOICE_JUICE[choice_number].nil?
      puts "0~3のみで入力してください。"
      choice(machine)
    elsif CHOICE_JUICE[choice_number] == "キャンセル"
      puts "キャンセルしました"
      machine.return_money
    else
      machine.buy_juice(choice_number, self)
    end
  end
end

class VendingMachine
  # ステップ０　お金の投入と払い戻しの例コード
  # ステップ１　扱えないお金の例コード
  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  MONEY = [10, 50, 100, 500, 1000].freeze
  attr_reader :juice, :sale
  attr_accessor :stock
  # （自動販売機に投入された金額をインスタンス変数の @slot_money に代入する）
  def initialize
    # 最初の自動販売機に入っている金額は0円
    @slot_money = 0
    @sale = 0
    @stock = []
  end

  # 投入金額の総計を取得できる。
  def current_slot_money
    # 自動販売機に入っているお金を表示する
    @slot_money
  end

  #初期に5個ずつ投入
  def stock_five_juice
    5.times do
      self.stock << Juice.create_each_juice
    end
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
    puts "#{@slot_money}のお釣りです"
    # 自動販売機に入っているお金を0円に戻す
    @slot_money = 0
  end

  def buy_juice(choice_juice, user)
    @user_select = @juice.select_juice[choice_juice]
    if @user_select == nil
      return puts "キャンセルしました"
    elsif @slot_money >= @user_select[:price] && @user_select[:stock] >= 1
      puts "#{@user_select[:name]}が出てきた"
      @user_select[:stock] -= 1
      total_sale(choice_juice)
      return_money
    elsif @user_select[:stock] == 0
      puts '売り切れです'
      user.choice(self)
    else
      puts "お金が足りません"
      user.choice(self)
    end
    # if @user_select == nil
    #   return puts "キャンセルしました"
    # elsif @slot_money >= @juice.price[choice_juice] && @juice.stock[choice_juice] >= 1
    #   puts "#{@juice.juice_name[choice_juice]}が出てきた"
    #   @juice.stock[choice_juice] -= 1
    #   total_sale(choice_juice)
    #   return_money
    # elsif @juice.stock[choice_juice] == 0
    #   puts '売り切れです'
    #   user.choice(self)
    # else
    #   puts "お金が足りません"
    #   user.choice(self)
    # end
  end

  def total_sale(choice_juice)
    @slot_money -= @user_select[:price]
    @sale += @user_select[:price]
  end
  # def total_sale(choice_juice)
  #   @slot_money -= @juice.price[choice_juice]
  #   @sale += @juice.price[choice_juice]
  # end
end

class Juice
  attr_reader :juice_name, :price
  def initialize(juice_name, price)
    @juice_name = juice_name
    @price = price
  end

  def self.create_each_juice
    juice_list = [['コーラ', 120], ['レッドブル', 200], ['水', 100]]
    juice_list.map do |juice|
      self.new(*juice)
    end
  end

  def select_juice
    juice_info = [{name: "コーラ", price: 120, stock: 5},
                  {name: "レッドブル", price: 200, stock: 5},
                  {name: "水", price: 100, stock: 5}
                 ]
  end
end

machine = VendingMachine.new
machine.stock_five_juice
puts machine.stock

#user = User.new
#6.times do
#  machine.slot_money(100)
#  machine.slot_money(50)
#  choice_juice = user.choice(machine)
#  binding.irb
#end

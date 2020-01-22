require './lib/User'
require './lib/Juice'
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

class VendingMachine
  # ステップ０　お金の投入と払い戻しの例コード
  # ステップ１　扱えないお金の例コード
  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  MONEY = [10, 50, 100, 500, 1000].freeze
  attr_reader :sale
  attr_accessor :stock
  # （自動販売機に投入された金額をインスタンス変数の @slot_money に代入する）
  def initialize
    # 最初の自動販売機に入っている金額は0円
    @slot_money = 0
    @sale = 0
    @stock = {}
  end

  # 投入金額の総計を取得できる。
  def current_slot_money
    # 自動販売機に入っているお金を表示する
    @slot_money
  end

  #初期に5個ずつ投入
  def stock_first_juice
    5.times do
      juices = Juice.create_each_juice
      juices.each do |juice|
        if @stock[juice.juice_name].nil?
          @stock[juice.juice_name] = [juice]
        else
          @stock[juice.juice_name].push(juice)
        end
      end
    end
  end

  def stock_juice(juice_name, price)
    juice = Juice.new(juice_name, price)
    if stock[juice.juice_name].nil?
      stock[juice.juice_name] = [juice]
      User::CHOICE_JUICE.insert(-2, juice_name)
      User::JUICE_PRICE.push(price)
    else
      stock[juice.juice_name].push(juice)
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
    puts "#{@slot_money}円のお釣りです"
    # 自動販売機に入っているお金を0円に戻す
    @slot_money = 0
  end

  #userが選んだジュースの購入処理
  def buy_juice(choice_number, user)
    if @stock[User::CHOICE_JUICE[choice_number]].empty?
      puts '売り切れです'
      user.choice(self)
    elsif User::JUICE_PRICE[choice_number] > @slot_money
      puts "お金が足りません"
      user.choice(self)
    else
      puts "#{User::CHOICE_JUICE[choice_number]}が出てきた"
      @stock[User::CHOICE_JUICE[choice_number]].shift
      total_sale(choice_number)
      return_money
    end
    #if @slot_money >= @user_select[:price] && @user_select[:stock] >= 1
    #  puts "#{@user_select[:name]}が出てきた"
    #  @user_select[:stock] -= 1
    #  total_sale(choice_juice)
    #  return_money
    #elsif @user_select[:stock] == 0
    #  puts '売り切れです'
    #  user.choice(self)
    #else
    #  puts "お金が足りません"
    #  user.choice(self)
    #end
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

  #購入後の返金額、売上額算定用
  def total_sale(choice_number)
    @slot_money -= User::JUICE_PRICE[choice_number]
    @sale += User::JUICE_PRICE[choice_number]
  end
  # def total_sale(choice_juice)
  #   @slot_money -= @juice.price[choice_juice]
  #   @sale += @juice.price[choice_juice]
  # end
end


machine = VendingMachine.new
#user = User.new
#6.times do
#  machine.slot_money(100)
#  machine.slot_money(50)
#  choice_juice = user.choice(machine)
#end

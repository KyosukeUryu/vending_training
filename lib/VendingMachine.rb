require './lib/User'
require './lib/Juice'

class VendingMachine
  # 10円玉、50円玉、100円玉、500円玉、1000円札を１つずつ投入できる。
  MONEY = [10, 50, 100, 500, 1000].freeze
  attr_reader :sale, :juice_name_list, :juice_price_list
  attr_accessor :stock
  attr_writer :slot_money
  # （自動販売機に投入された金額をインスタンス変数の @slot_money に代入する）
  def initialize
    # 最初の自動販売機に入っている金額は0円
    @slot_money = 0
    @sale = 0
    @stock = {}
    # 各自販機にストックされる飲み物の名前と金額をリスト化した変数
    @juice_name_list = ['キャンセル']
    @juice_price_list = []
  end

  # Userクラスのインスタンスが投入した現金を反映させる
  def fund_money(money)
    @slot_money += money
  end
  # 投入金額の総計を取得できる。
  def current_slot_money
    # 自動販売機に入っているお金を表示する
    @slot_money
  end

  # 初期にコーラ、レッドブル、水を５個ずつ投入
  def stock_first_juice
    5.times do
      juices = Juice.create_each_juice
      juices.each do |juice|
        self.juice_insert_first?(juice)
      end
    end
  end

  # ジュース追加メソッド、numに数値を入れればその個数ストック、デフォルトは１個
  def stock_juice(juice_name, price, num = 1)
    num.times do
      juice = Juice.new(juice_name, price)
      self.juice_insert_first?(juice)
    end
  end

  # stockに投入されるインスタンスが初めて入る飲み物の場合キーとして設定するための判定を実施
  def juice_insert_first?(juice)
    if stock[juice.juice_name].nil?
      stock[juice.juice_name] = [juice]
      @juice_name_list.insert(-2, juice.juice_name)
      @juice_price_list.push(juice.price)
    else
      stock[juice.juice_name].push(juice)
    end
  end

  # 払い戻し操作を行うと、投入金額の総計を釣り銭として出力する。
  def return_money
    # 返すお金の金額を表示する
    puts "#{@slot_money}円のお釣りです"
    # 自動販売機に入っているお金を0円に戻す
    @slot_money = 0
  end

  # userが選んだジュースの購入処理
  def buy_juice(choice_number, user)
    if @stock[@juice_name_list[choice_number]].empty?
      puts '売り切れです'
      user.choice(self)
    elsif @juice_price_list[choice_number] > @slot_money
      puts "お金が足りません"
      user.choice(self)
    else
      puts "#{@juice_name_list[choice_number]}が出てきた"
      @stock[@juice_name_list[choice_number]].shift
      total_sale(choice_number)
      return_money
    end
  end

  # 購入後の返金額、売上額算定用
  def total_sale(choice_number)
    @slot_money -= @juice_price_list[choice_number]
    @sale += @juice_price_list[choice_number]
  end
end

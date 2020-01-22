class User
  #VendingMachineクラスで追加されたジュースの名前と価格が入る
  CHOICE_JUICE = ["キャンセル"]
  JUICE_PRICE = []

  def initialize(name: 'taro')
    @name = name
  end

  def slot_money(money, machine)
    # 想定外のもの（１円玉や５円玉。千円札以外のお札、そもそもお金じゃないもの（数字以外のもの）など）
    # が投入された場合は、投入金額に加算せず、それをそのまま釣り銭としてユーザに出力する。
    return false unless VendingMachine::MONEY.include?(money)
    # 自動販売機にお金を入れる
    machine.fund_money(money)
  end

  def juice_list(machine)
    puts "投入金額と在庫から買えるのは以下の飲み物です"
    #ストックの数だけforで表示する
    for i in 0..machine.stock.count - 1 do
      if machine.current_slot_money >= JUICE_PRICE[i] && !machine.stock[CHOICE_JUICE[i]].empty?
        puts "#{CHOICE_JUICE[i]}"
      end
    end
  end

  def choice(machine)
    juice_list(machine)
    puts "投入金額:#{machine.current_slot_money}円"
    for i in 0..machine.stock.count - 1 do
      puts "#{i}: #{CHOICE_JUICE[i]}:#{JUICE_PRICE[i]}円"
    end
    puts "#{CHOICE_JUICE.index("キャンセル")}: キャンセル"
    puts "数字を入力してください"

    choice_number = Integer(gets.chomp) rescue nil

    if choice_number == nil || CHOICE_JUICE[choice_number].nil?
      puts "0~#{CHOICE_JUICE.count - 1}のみで入力してください。"
      choice(machine)
    elsif CHOICE_JUICE[choice_number] == "キャンセル"
      puts "キャンセルしました"
      machine.return_money
    else
      machine.buy_juice(choice_number, self)
    end
  end
end


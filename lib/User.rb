class User
  CHOICE_JUICE = ["コーラ", "レッドブル", "水", "キャンセル"]
  JUICE_PRICE = [120, 200, 100]

  def initialize(name: 'taro')
    @name = name
  end

  def juice_list(machine)
    puts "投入金額と在庫から買えるのは以下の飲み物です"
    for i in 0..2 do
      if machine.current_slot_money >= JUICE_PRICE[i] && !machine.stock[CHOICE_JUICE[i]].empty?
        puts "#{CHOICE_JUICE[i]}"
      end
    end
  end

  def choice(machine)
    juice_list(machine)
    puts "投入金額:#{machine.current_slot_money}円"
    for i in 0..2 do
      puts "#{i}: #{CHOICE_JUICE[i]}:#{JUICE_PRICE[i]}円"
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

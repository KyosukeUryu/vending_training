class Juice
  attr_reader :juice_name, :price
  def initialize(juice_name, price)
    @juice_name = juice_name
    @price = price
  end

  # コーラ、レッドブル、水のインスタンスを１個ずつ格納した配列を返す
  def self.create_each_juice
    juice_list = [['コーラ', 120], ['レッドブル', 200], ['水', 100]]
    juice_list.map do |juice|
      self.new(*juice)
    end
  end
end


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


require 'minitest/autorun'
require './lib/VendingMachine'
require './lib/Juice'
require './lib/User'

class VendingMachineTest < Minitest::Test
  def setup
    @vend = VendingMachine.new
    @user = User.new
    @vend.stock_first_juice
    @user.slot_money(100, @vend)
    @user.slot_money(10, @vend)
    @user.slot_money(10, @vend)
  end

  def test_stock_first_juice
    assert_equal @vend.stock.count, 3
    assert_equal @vend.stock.keys.first, 'コーラ'
    assert_equal @vend.stock.values.first.count, 5
    assert_equal @vend.juice_price_list.first, 120
    assert_equal @vend.juice_name_list.first, 'コーラ'
  end

  def test_slot_money
    assert_equal @vend.current_slot_money, 120
    refute @user.slot_money(1, @vend)
    refute @user.slot_money(10000, @vend)
  end

  def test_buy_juice
    @vend.buy_juice(2, @user)
    assert_equal 4, @vend.stock["水"].count
    assert_equal 100, @vend.sale
    assert_equal 5, @vend.stock["コーラ"].count
  end
end

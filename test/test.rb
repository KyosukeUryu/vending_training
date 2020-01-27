require 'minitest/autorun'
require './lib/VendingMachine'
require './lib/Juice'
require './lib/User'

class VendingMachineTest < Minitest::Test
  def test_new_user
    user = User.new
    assert_equal user.name, 'taro'
  end
end

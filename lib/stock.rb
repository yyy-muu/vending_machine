class Stock
  attr_accessor :stocks

  def initialize(drink)
    @stocks = [drink]
  end

  def add_drink(drink)
    @stocks << drink
  end

  def show_stocks
    @stocks.each do |drink|
      puts "#{drink.name}: ¥#{drink.price}, Remaining: #{drink.quantity}"
    end
  end
end

class Stock
  attr_accessor :stock

  @@stock = {}

  def add_stock(drink, quantity)
    # @@stock内に、既に同じ商品がある場合、オブジェクトは作らず在庫だけ足し上げる)
    if @@stock.include?(drink)
      @@stock[drink] += quantity
    else
      # @@stock内に同じ商品がない場合、飲み物名をキー、在庫数を値として追加
      @@stock[drink] = quantity
    end
  end

  def delete_stock(drink, quantity)
    @@stock[drink] -= quantity
  end

  def find_stock(drink)
    @@stock.include?(drink)
  end

  def show_stock
    @@stock.each_key do |drink|
      puts "#{drink.name}, " + "¥#{drink.price}, " + "Remaining: #{@@stock[drink]}"
    end
  end
end

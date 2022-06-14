class VendingMachine
  def initialize(stock)
    @stocks = stock
    @total_sales = 0
    @sales_info = []
  end

  def add_stocks(stock, name, price, quantity)
    # @stocks内に、既に同じ商品がある場合、オブジェクトは作らず在庫だけ足し上げる)
    exsisting_drinks = stock.stocks.find { |drink| drink.name == name }
    if exsisting_drinks
      exsisting_drinks.quantity += quantity
    else
      # @stocks内に同じ商品がない場合、新規追加する
      drink = Drink.new(name, price, quantity)
      stock.add_drink(drink)
    end
  end

  def show_stocks
    @stocks.show_stocks
  end

  def show_total_sales
    @total_sales
  end

  def show_sales_info
    @sales_info
  end

  def purchase(stock, drink_name, suica)
    buyable_drinks = stock.stocks.select { |drink| drink.quantity.positive? }
    selected_drink = stock.stocks.find { |drink| drink.name == drink_name }

    return unless buyable_drinks && selected_drink.quantity.positive? && suica.balance >= selected_drink.price

    # 在庫・売上・残高に反映
    suica.balance -= selected_drink.price
    selected_drink.quantity -= 1
    @total_sales += selected_drink.price

    # 販売日時とSuica利用者の年齢と性別を記録
    sale_date = Time.now
    @sales_info.push(selected_drink.name, suica.age, suica.gender, sale_date.strftime("%H:%M"))
  end
end

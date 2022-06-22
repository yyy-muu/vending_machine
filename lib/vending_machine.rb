class VendingMachine
  def initialize
    @total_sales = 0
    @sales_info = []
  end

  def show_total_sales
    @total_sales
  end

  def show_sales_info
    @sales_info
  end

  def purchase(stock, drink, quantity, suica)
    check_stock = stock.find_stock(drink)

    return unless check_stock && suica.balance >= drink.price

    # 在庫・売上・残高に反映
    suica.balance -= drink.price * quantity
    stock.delete_stock(drink, quantity)
    @total_sales += drink.price * quantity

    # 販売日時とSuica利用者の年齢と性別を記録
    sold_at = Time.now
    @sales_info.push(drink.name, suica.age, suica.gender, sold_at.strftime("%H:%M"))
  end
end

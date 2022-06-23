class Suica
  attr_reader :age, :gender
  attr_accessor :balance

  def initialize(age, gender, balance = 0)
    @age = age
    @gender = gender
    @balance = balance
  end

  def charge(money)
    if money < 100
      '¥100以上をチャージしてください'
    else
      @balance += money
      "チャージ金額：¥#{money} / 残高：¥#{@balance}"
    end
  end
end

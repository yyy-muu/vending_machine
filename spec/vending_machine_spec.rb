require_relative '../spec/spec_helper'
require_relative '../lib/vending_machine'
require_relative '../lib/stock'
require_relative '../lib/drink'

RSpec.describe VendingMachine do
  let(:coke) { Drink.new('coke', 120, 5) }
  let(:redbull) { Drink.new('redbull', 200, 5) }
  let(:zaiko) { Stock.new(coke) }
  let!(:vending_machine) { VendingMachine.new(zaiko) }
  let(:suica) { Suica.new(25, 'female') }

  describe '#add_stocks' do
    before do
      vending_machine.add_stocks(zaiko, 'coke', 120, 5)
      vending_machine.add_stocks(zaiko, 'redbull', 200, 5)
    end

    context 'when stocks already have same drink' do
      it 'add 5 coke stocks then quantity become 10' do
        coke = zaiko.stocks.find { |drink| drink.name == 'coke' }
        expect(coke.quantity).to eq 10
      end
    end

    context 'when stocks have no same drink' do
      it 'add 5 redbulls as new stocks' do
        redbull = zaiko.stocks.find { |drink| drink.name == 'redbull' }
        expect(redbull.quantity).to eq 5
      end
    end
  end

  describe '#show_stocks' do
    it 'show all stocks' do
      expect(vending_machine.show_stocks).to include coke
    end
  end

  describe '#show_total_sales' do
    it 'show sales amount at the moment' do
      expect(vending_machine.show_total_sales).to eq 0
    end
  end

  describe '#show_sales_info' do
    before do
      suica.charge(200)
      vending_machine.purchase(zaiko, 'coke', suica)
      @sale_date = Time.now.strftime("%H:%M")
    end

    it 'get sale date, customers age and gender from suica' do
      expect(vending_machine.show_sales_info).to eq ["coke", 25, "female", @sale_date]
    end
  end

  describe '#purchase' do
    context 'when stock and balance are enough to buy drink' do
      before do
        suica.charge(200)
        vending_machine.purchase(zaiko, 'coke', suica)
        @total_sales = 0
        @sales_info = []
        @sale_date = Time.now.strftime("%H:%M")
        coke = zaiko.stocks.find { |drink| drink.name == 'coke' }
        @sales_info.push(coke.name, suica.age, suica.gender, @sale_date)
      end

      it 'balance become ¥80' do
        expect(suica.balance).to eq 80
      end

      it 'coke stocks become 4' do
        expect(coke.quantity).to eq 4
      end

      it 'total sales become ¥120' do
        @total_sales += coke.price
        expect(@total_sales).to eq 120
      end

      it 'record sale date, customers age and gender as sales info' do
        expect(@sales_info).to eq ["coke", 25, "female", @sale_date]
      end
    end

    context 'when stock is enough but balance is not enough' do
      before do
        suica.charge(100)
        vending_machine.purchase(zaiko, 'coke', suica)
        @total_sales = 0
        coke = zaiko.stocks.find { |drink| drink.name == 'coke' }
      end

      it 'balance keep ¥100' do
        expect(suica.balance).to eq 100
      end

      it 'coke stocks keep 5' do
        expect(coke.quantity).to eq 5
      end

      it 'total sales keeps ¥0' do
        expect(@total_sales).to eq 0
      end
    end

    context 'when balance is enough but there is no stock' do
      before do
        suica.charge(200)
        vending_machine.add_stocks(zaiko, 'redbull', 200, 0)
        vending_machine.purchase(zaiko, 'redbull', suica)
        @total_sales = 0
        redbull = zaiko.stocks.find { |drink| drink.name == 'redbull' }
      end

      it 'balance keep ¥200' do
        expect(suica.balance).to eq 200
      end

      it 'redbull stocks keep 5' do
        expect(redbull.quantity).to eq 5
      end

      it 'total sales keep ¥0' do
        expect(@total_sales).to eq 0
      end
    end

    context 'when both balance and stock are not enough' do
      before do
        suica.charge(100)
        vending_machine.add_stocks(zaiko, 'redbull', 200, 0)
        vending_machine.purchase(zaiko, 'redbull', suica)
        @total_sales = 0
        redbull = zaiko.stocks.find { |drink| drink.name == 'redbull' }
      end

      it 'balance keep ¥200' do
        expect(suica.balance).to eq 100
      end

      it 'redbull stocks keep 5' do
        expect(redbull.quantity).to eq 5
      end

      it 'total sales keep ¥0' do
        expect(@total_sales).to eq 0
      end
    end
  end
end

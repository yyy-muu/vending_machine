require_relative '../spec/spec_helper'
require_relative '../lib/vending_machine'
require_relative '../lib/stock'
require_relative '../lib/drink'

RSpec.describe VendingMachine do
  let(:coke) { Drink.new('coke', 120) }
  let(:redbull) { Drink.new('redbull', 200) }
  let(:water) { Drink.new('water', 100) }
  let!(:vending_machine) { VendingMachine.new }
  let(:suica) { Suica.new(25, 'female') }

  describe '#show_total_sales' do
    before do
      suica.charge(200)
      zaiko1 = Stock.new
      zaiko1.add_stock(coke, 5)
      vending_machine.purchase(zaiko1, coke, 1, suica)
    end

    it 'show sales amount at the moment' do
      expect(vending_machine.show_total_sales).to eq 120
    end
  end

  describe '#show_sales_info' do
    before do
      suica.charge(200)
      zaiko2 = Stock.new
      zaiko2.add_stock(coke, 5)
      vending_machine.purchase(zaiko2, coke, 1, suica)
      @sold_at = Time.now.strftime("%H:%M")
    end

    it 'get sale date, customers age and gender from suica' do
      expect(vending_machine.show_sales_info).to eq ["coke", 25, "female", @sold_at]
    end
  end

  describe '#purchase' do
    before do
      @zaiko = Stock.new
      @zaiko.add_stock(coke, 5)
    end

    context 'when stock and balance are enough to buy drink' do
      before do
        suica.charge(300)
        @total_sales = 0
        @sales_info = []
        @sold_at = Time.now.strftime("%H:%M")
        @sales_info.push(coke.name, suica.age, suica.gender, @sold_at)
        vending_machine.purchase(@zaiko, coke, 2, suica)
      end

      it 'coke stock become 3' do
        expect(@zaiko.show_stock.count).to eq 3
      end

      it 'balance become ¥60' do
        expect(suica.balance).to eq 60
      end

      it 'total sales become ¥240' do
        @total_sales += coke.price * 2
        expect(@total_sales).to eq 240
      end

      it 'record sale date, customers age and gender as sales info' do
        expect(@sales_info).to eq ["coke", 25, "female", @sold_at]
      end
    end

    context 'when stock is enough but balance is not enough' do
      before do
        suica.charge(100)
        vending_machine.purchase(@zaiko, coke, 2, suica)
        @total_sales = 0
      end

      it 'balance keep ¥100' do
        expect(suica.balance).to eq 100
      end

      it 'coke stock keeps 8' do
        # コーラ2個購入済、beforeメソッドで5個追加 :在庫合計8個
        expect(@zaiko.show_stock.count).to eq 8
      end

      it 'total sales keeps ¥0' do
        expect(@total_sales).to eq 0
      end
    end

    context 'when balance is enough but there is no stock' do
      before do
        suica.charge(200)
        vending_machine.purchase(@zaiko, redbull, 1, suica)
        @total_sales = 0
      end

      it 'balance keep ¥200' do
        expect(suica.balance).to eq 200
      end

      it 'total sales keep ¥0' do
        expect(@total_sales).to eq 0
      end
    end

    context 'when both balance and stock are not enough' do
      before do
        suica.charge(100)
        vending_machine.purchase(@zaiko, water, 2, suica)
        @total_sales = 0
      end

      it 'balance keep ¥200' do
        expect(suica.balance).to eq 100
      end

      it 'total sales keep ¥0' do
        expect(@total_sales).to eq 0
      end
    end
  end
end

RSpec.describe Stock do
  let(:coke) { Drink.new('coke', 120) }
  let(:zaiko3) { Stock.new }
  before(:each) { Stock.class_variable_set :@@stock, {} }

  before do
    zaiko3.add_stock(coke, 5)
  end

  describe '#add_stock' do
    it 'verify method is valid' do
      expect(zaiko3.add_stock(coke, 5)).to be_truthy
    end
  end

  describe '#delete_stock' do
    it 'verify method is valid' do
      expect(zaiko3.delete_stock(coke, 5)).to be_truthy
    end
  end

  describe '#find_stock' do
    it 'verify method is valid' do
      expect(zaiko3.find_stock(coke)).to be_truthy
    end
  end

  describe '#show_stock' do
    it 'show all stock' do
      expect(zaiko3.show_stock).to include coke
    end
  end
end

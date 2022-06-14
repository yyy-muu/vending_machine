require_relative '../spec/spec_helper'
require_relative '../lib/stock'
require_relative '../lib/drink'

RSpec.describe Stock do
  let(:coke) { Drink.new('coke', 120, 5) }
  let(:water) { Drink.new('water', 200, 5) }
  let(:zaiko) { Stock.new(coke) }

  describe '#add_drink' do
    it 'verify method is valid' do
      expect(zaiko.add_drink(water)).to be_truthy
    end
  end

  describe '#show_stocks' do
    it 'verify method is valid' do
      expect(zaiko.show_stocks).to be_truthy
    end
  end
end

require_relative '../spec/spec_helper'
require_relative '../lib/drink'

RSpec.describe Drink do
  describe '#initialize' do
    it 'verify generating Drink instance' do
      expect(Drink.new('coke', 120, 5)).to be_truthy
    end
  end
end
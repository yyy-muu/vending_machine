require_relative '../spec/spec_helper'
require_relative '../lib/suica'

RSpec.describe Suica do
  describe '#charge' do
    before do
      @suica = Suica.new(25, 'female')
    end

    context 'when put ¥100 or more' do
      it 'show how much put and balance' do
        expect(@suica.charge(100)).to eq 'チャージ金額：¥100 / 残高：¥100'
      end
    end

    context 'when put less than ¥100' do
      it 'show message to put ¥100 or more' do
        expect(@suica.charge(99)).to eq '¥100以上をチャージしてください'
      end
    end
  end
end

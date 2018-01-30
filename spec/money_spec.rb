RSpec.describe Money do
  describe '#conversions_rate' do
    before do
      Money.conversion_rates('EUR', 'BTC' => 0.01, 'USD' => 2)
    end

    it { expect(Money.rates.keys).to include('EUR') }
    it { expect(Money.rates.keys).to include('BTC') }
    it { expect(Money.rates.keys).to include('USD') }

    it { expect(Money.rates['EUR']).to eq('BTC' => 0.01, 'USD' => 2.00)    }
    it { expect(Money.rates['BTC']).to eq('EUR' => 100.00, 'USD' => 200.00)   }
    it { expect(Money.rates['USD']).to eq('EUR' => 0.5, 'BTC' => 0.005) }
  end

  describe '#new' do
    let(:coin) { Money::Coin.new(50.00, 'USD') }
    subject    { Money.new(50, 'USD')          }

    it { is_expected.to eq(coin)               }
    it { expect(subject.amount).to eq(50.00)   }
    it { expect(subject.currency).to eq('USD') }
  end
end

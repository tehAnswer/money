RSpec.describe Money::Coin do
  before(:all) do
    Money.conversion_rates('EUR', 'USD' => 2.00, 'BTC' => 0.01)
  end

  describe 'sum (same currency)' do
    let(:c1) { described_class.new(1.00, 'EUR') }

    subject { c1 + c1 }
    it { expect(subject.amount).to eq(2.0) }
    it { expect(subject.currency).to eq('EUR') }
  end

  describe 'sum (other currency)' do
    let(:c1) { described_class.new(1.00, 'EUR') }
    let(:c2) { described_class.new(1.00, 'BTC') }

    subject { c1 + c2 }
    it { expect(subject.amount).to eq(101.00)  }
    it { expect(subject.currency).to eq('EUR') }
  end

  describe 'substraction (same currency)' do
    let(:c1) { described_class.new(4.00, 'EUR') }
    let(:c2) { described_class.new(1.00, 'EUR') }

    subject { c1 - c2 }
    it { expect(subject.amount).to eq(3.00)    }
    it { expect(subject.currency).to eq('EUR') }
  end

  describe 'substraction (other currency)' do
    let(:c1) { described_class.new(4.00, 'EUR') }
    let(:c2) { described_class.new(1.00, 'USD') }

    subject { c1 - c2 }
    it { expect(subject.amount).to eq(3.50)    }
    it { expect(subject.currency).to eq('EUR') }
  end

  # It takes the currency of the first operand.
  describe 'coin_operations currency result' do
    let(:c1) { described_class.new(1.00, 'EUR') }
    let(:c2) { described_class.new(1.00, 'BTC') }

    it { expect((c1 + c2).currency).to eq('EUR') }
    it { expect((c2 + c1).currency).to eq('BTC') }
    it { expect((c1 - c2).currency).to eq('EUR') }
    it { expect((c2 - c1).currency).to eq('BTC') }
  end

  describe 'multiplication' do
    let(:c1) { described_class.new(4.00, 'EUR') }

    subject { c1 * 2 }
    it { expect(subject.amount).to eq(8.00)    }
    it { expect(subject.currency).to eq('EUR') }
  end

  describe 'division' do
    let(:c1) { described_class.new(4.00, 'EUR') }

    subject { c1 / 4 }
    it { expect(subject.amount).to eq(1.00)    }
    it { expect(subject.currency).to eq('EUR') }
  end

  describe 'division by zero' do
    let(:c1) { described_class.new(4.00, 'EUR') }

    it 'throws error' do
      expect { c1 / 0 }.to raise_error(ArgumentError)
    end
  end

  describe 'greater_than (same currency)' do
    let(:c1) { described_class.new(4.00, 'EUR') }
    let(:c2) { described_class.new(1.00, 'EUR') }

    subject { c1 > c2 }
    it { expect(subject).to be_truthy }
  end

  describe 'greater_than (other currency)' do
    let(:c1) { described_class.new(4.00, 'EUR') }
    let(:c2) { described_class.new(100.00, 'USD') }

    subject { c1 > c2 }
    it { expect(subject).to be_falsey }
  end

  describe 'less_than (same currency)' do
    let(:c1) { described_class.new(4.00, 'EUR') }
    let(:c2) { described_class.new(1.00, 'EUR') }

    subject { c1 < c2 }
    it { expect(subject).to be_falsey }
  end

  describe 'less_than (other currency)' do
    let(:c1) { described_class.new(4.00, 'EUR') }
    let(:c2) { described_class.new(1.00, 'BTC') }

    subject { c1 < c2 }
    it { expect(subject).to be_truthy }
  end

  describe 'equality (same currency)' do
    let(:c1) { described_class.new(1.00, 'EUR') }
    let(:c2) { described_class.new(2.00, 'BTC') }

    subject { c1 == c2 }
    it { expect(subject).to be_falsey }
  end

  describe 'equality (other currency)' do
    let(:c1) { described_class.new(2.00, 'EUR') }
    let(:c2) { described_class.new(0.02, 'BTC') }

    subject { c1 == c2 }
    it { expect(subject).to be_truthy }
  end

  describe 'greater_or_equal_than' do
    let(:c1) { described_class.new(2.02, 'EUR') }
    let(:c2) { described_class.new(0.02, 'BTC') }

    subject { c1 >= c2 }
    it { expect(subject).to be_truthy }
  end

  describe 'less_or_equal_than' do
    let(:c1) { described_class.new(2.00, 'EUR') }
    let(:c2) { described_class.new(0.02, 'BTC') }

    subject { c1 <= c2 }
    it { expect(subject).to be_truthy }
  end

end

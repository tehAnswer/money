require_relative 'money/version'
require_relative 'money/coin'

module Money
  UnknownCurrency = ArgumentError.new('Such currency does not exist.').freeze
  InvalidRates = ArgumentError.new('Rates need to have a numeric value associated.').freeze
  DivisionByZero = ArgumentError.new('Divisions by zero are not allowed.').freeze

  def self.rates
    @rates || {}
  end

  def self.conversion_rates(currency, exchanges)
    # It will calculate the relative value between coins given the base
    # currency.
    raise InvalidRates unless exchanges.values.all? { |v| v.respond_to?(:to_f) }
    currency_values = exchanges.transform_values(&:to_f).merge(currency => 1.00)
    crossed_rates = currency_values.map do |(child_currency, value)|
      other_currencies = currency_values.reject { |k, _| k == child_currency }
      crossed_exchanges = other_currencies.map { |c, v| [c, v.fdiv(value)] }
      [child_currency, crossed_exchanges.to_h]
    end
    @rates = crossed_rates.to_h
  end

  def self.new(amount, currency)
    raise UnknownCurrency unless @rates.include?(currency)
    Coin.new(amount, currency)
  end
end

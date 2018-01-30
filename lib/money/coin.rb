module Money
  # A coin represents an amount of a given money. This class defines methods to
  # operate with such quantities of money, regardless if there are expressed in
  # the same or different currency.
  class Coin
    attr_accessor :amount, :currency

    def initialize(amount, currency)
      raise Money::InvalidAmount unless amount.respond_to?(:to_f)
      @amount = amount.to_f
      @currency = currency
    end

    def convert_to(new_currency)
      return self if currency == new_currency
      rates = Money.rates[currency]
      raise Money::UnknownCurrency unless rates.include?(new_currency)
      Coin.new(@amount * rates[new_currency], new_currency)
    end

    # NOTE: Too much magic happening here. Even though this black practises
    # are discouraged in the community, the truth is that some times they become
    # handy. I decided to use it because this code will hardly even change and
    # allowed a really nice refactor. In other scenarios, my cup of tea is to go
    # with methods defined statically.
    {
      arithmetics_operation:  [:/, :*],
      coin_operation:         [:+, :-],
      logic_operation:        [:>, :>=, :<, :<=, :==]
    }.each do |opt_type, methods|
      methods.each do |operation|
        define_method operation do |coin|
           send(opt_type, coin, operation)
        end
      end
    end

    private

    def arithmetics_operation(number, method)
      raise Money::DivisionByZero if number == 0 && method == :/
      Coin.new(amount.send(method, number), currency)
    end

    def coin_operation(coin, method)
      coin = coin.convert_to(currency) if coin.currency != currency
      Coin.new(amount.send(method, coin.amount), currency)
    end

    def logic_operation(coin, method)
      coin = coin.convert_to(currency) if coin.currency != currency
      amount.send(method, coin.amount)
    end
  end
end

module Money
  class Coin
    attr_accessor :amount, :currency

    def initialize(amount, currency)
      @amount = amount.to_f
      @currency = currency
    end

    def convert_to(new_currency)
      return self if currency == new_currency
      raise Money::UnknownCurrency unless @rates.include?(new_currency)
      Coin.new(@amount * Money.rates.dig(currency, new_currency), new_currency)
    end

    {
      arithmetics_operation:  [:/, :*],
      coin_operation:         [:+, :-],
      logic_operation:        [:>, :>=, :<, :<=, :==]
    }.each do |opt_type, methods|
      methods.each do |operation|
        define_method operation do |coin|
          send(opt_type, coin)
        end
      end
    end

    private

    def arithmetics_operation(number, method)
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

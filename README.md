# Money

![Cash Rules Everything Around Me, CREAM](https://www.earlytorise.com/wp-content/uploads/2013/03/ben-franklin.jpg)

This is just a simple gem which models operations such as sums, substractions, divisions or multiplication with different currencies.



## Usage

```ruby
require 'money'

# First, set the conversion rates.
Money.conversion_rates('EUR', 'BTC' => 5000.00, 'USD' => 0.81)

# Then, you can perform operations with the money!
fifty_cent = Money.new(0.50, 'USD')
fifty_cent.amount            #  => 0.50
fifty_cent.currency          #  => "USD"

# Such as conversion!
fifty_cent.convert_to('EUR') #  => 0.405
fifty_cent.convert_to('BTC') #  => 0.000081

# Or sums, substractions, multiplications and divisions!
fifty_cent * 2 i         # => Money.new(1.00, 'USD')
fifty_cent + fifty_cent  # => Money.new(1.00, 'USD')
fifty_cent / 5           # => Money.new(0.10, 'USD') 

# Also complicated comparisons!
Money.new(50.00, 'USD') + Money.new(100.00, 'EUR') > Money.new(1.00, 'BTC') #  => false
Money.new(5000.00, 'EUR') == Money.new(1.00, 'BTC') # => true
```

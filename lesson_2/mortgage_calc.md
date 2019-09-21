m = p * ( j / ( 1 - ( 1 + j ) ** ( -n ) ) )

m = monthly payments                 => to be calculated
p = loan amount                           => amount applied for
j = monthly interest                    => month_interest
n = loan duration in months         => amount_in_months

There are, however, some methods that are convoluted because the logic is complex. It's likely a sign that you don't quite understand the problem well enough to break it down into well-compartmentalized pieces. That's fine. But you will understand the problem better as you dig into the code more and more, and as your understanding becomes more clear, refactor your code to reflect that growing clarity.
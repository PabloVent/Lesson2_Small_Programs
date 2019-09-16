def prompt(message)
  puts "=> #{message}"
end

def validate_name?(name_str)
  /^[a-zA-ZŒÂÊÁËÈØÅÍÎÏÌÓÔÒÚÆŸÛÙÇ]\p{L}+$/.match(name_str) \
  || /^\p{L}[a-zA-ZŒÂÊÁËÈØÅÍÎÏÌÓÔÒÚÆŸÛÙÇÊ]+$/.match(name_str) \
end 

def validate_number?(input)
  validate_integer?(input) || validate_float?(input)
end

def validate_integer?(input)
  /^-?\d+(\.\d+)?$/.match(input)
end

def validate_float?(input)
  /\d/.match(input) && /^-\d*\.?\d*$/.match(input)
end

prompt("Welcome to mortgage calculator")

prompt("Please state your first name")
first_name = Kernel.gets().chomp().capitalize().strip()


prompt("Please state your last name")
last_name = Kernel.gets().chomp().capitalize().strip()

full_name = first_name + " " + last_name

loop do
prompt("Please tell us what loan amount are you applying for")
  loan_amout = Kernel.gets().chomp().strip() 

# validate input

  prompt("Tell us the interest rate you're thinking of")
  interest_rate = Kernel.gets().chomp().strip()

  # validate input 

  prompt("Tell us the duration you want to spread your loan over")
  loan_duration = Kernel.gets().chomp().strip()

  # validate input

# calculate:

# translate APR in months
  # annual_interest = interest_rate ÷ 100
  # month_interest = annual_interest ÷ 12

# translate loan duration into months
  # amount_in_months =  loan_duration * 12

#  calculate monthly payments => m = p * ( j / ( 1 - ( 1 + j ) ** ( -n ) ) )  

# m = monthly payments                 => to be calculated
# p = loan amount                           => amount_in_months
# j = monthly interest                    => month_interest
# n = loan duration in months         => amount_in_months
  break
end




require 'yaml'

MESSAGES = YAML.load_file('mortgage_calc.yml')

language = "en"

def messages(message, lang)
  MESSAGES[lang][message]
end

def prompt(message, msg2=nil)
  puts "=> #{message}#{msg2}"
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

def retrieve_name(language)
  name = ""
  loop do
    name = Kernel.gets().chomp().strip().capitalize()
    if name.empty? || !(validate_name?(name))
      prompt(messages('validate_name', language))
    else
      break
    end
  end
  name
end

prompt(messages('welcome', language)) # Welcome, state your name
name = retrieve_name(language)
prompt(messages('greet', language) % { name_param: name }) # Hi #{name}....

loop do
  def retrieve_loan_amount(language)
    loan_amount = ''
    loop do
      prompt(messages('loan_amount', language))
      loan_amount = Kernel.gets().chomp().strip()

      if validate_number?(loan_amount) && loan_amount > '0'
        break
      else
        prompt(messages('invalid_number', language))
      end
    end
    loan_amount
  end
  loan_amount = retrieve_loan_amount(language).to_f

  def retrieve_inter_rate(language)
    interest_rate = ''
    loop do
      prompt(messages('interest_rate', language))
      prompt(messages('example', language))
      interest_rate = Kernel.gets().chomp().strip()

      if validate_number?(interest_rate) && interest_rate > '0'
        break
      else
        prompt(messages('invalid_number', language))
      end
    end
    interest_rate                                                        
  end
  interest_rate = retrieve_inter_rate(language).to_f

  def retrieve_duration(language)
    loan_duration = ''
    loop do
      prompt(messages('loan_length', language))
      loan_duration = Kernel.gets().chomp().strip()

      if validate_number?(loan_duration) && loan_duration.to_i <= 12 \
        && loan_duration.to_i > 0
        break
      elsif loan_duration == '0'
        prompt(messages('zero_division', language))
      else
        prompt(messages('invalid_number', language))
      end
    end
    loan_duration.to_i                                                      
  end
  loan_duration = retrieve_duration(language)

  annual_interest_rate = interest_rate / 100
  month_interest_rate = annual_interest_rate / 12
  amount_in_months =  loan_duration * 12

  monthly_payments = loan_amount * (month_interest_rate / \
                                  (1 - (1 + month_interest_rate)**\
                                  (- amount_in_months)))

  # prompt("Your monthly payment is: £#{format('%02.2f', monthly_payments)}")
  prompt(messages('instalment', language), format('%02.2f', monthly_payments))

  break
end

# m = p * ( j / ( 1 - ( 1 + j ) ** ( -n ) ) )

# m = monthly payments                 => to be calculated
# p = loan amount                           => amount applied for
# j = monthly interest                    => month_interest
# n = loan duration in months         => amount_in_months

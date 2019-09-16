require 'yaml'

MESSAGES = YAML.load_file('mortgage_calc.yml')

language = "en"

def messages(message, lang)
  MESSAGES[lang][message]
end

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

      if validate_number?(loan_amount)
        break
      else
        prompt(messages('invalid_number', language))
      end
    end
    loan_amount
  end
  loan_amount = retrieve_loan_amount(language)                  # loan_amount

  def retrieve_inter_rate(language)
    interest_rate = ''
    loop do
      prompt(messages('interest_rate', language))
      interest_rate = Kernel.gets().chomp().strip() 

      if validate_number?(interest_rate)
        break
      else
        prompt(messages('invalid_number', language))
      end
    end
    interest_rate                                                                   # interest_rate
  end
  interest_rate = retrieve_inter_rate(language)

  def retrieve_duration(language)
    loan_duration = ''
    loop do
      prompt(messages('loan_length', language))
      loan_duration = Kernel.gets().chomp().strip() 

      if validate_number?(loan_duration)
        break
      else
        prompt(messages('invalid_number', language))
      end
    end
    loan_duration                                                                  # loan_duration
  end
  loan_duration = retrieve_duration(language)

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




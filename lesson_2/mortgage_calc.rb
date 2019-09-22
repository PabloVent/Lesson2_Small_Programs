require 'yaml'

MESSAGES = YAML.load_file('mortgage_calc.yml')

language = "en"

def validate_number?(number_input)
  number_input.sub!(/^[0]+/, '')
  validate_integer?(number_input) || validate_float?(number_input)
end

def validate_integer?(number_input)
  (/^-?\d+(\.\d+)?$/.match(number_input)) && !(/^0+\.0+$/ =~ number_input)
end

def validate_float?(number_input)
  /\d/.match(number_input) && /^-\d*\.?\d*$/.match(number_input) \
  && /^0+\.0+$/ =~ number_input
end

def messages(message, lang)
  MESSAGES[lang][message]
end

def prompt(message, msg2=nil)
  puts "=> #{message}#{msg2}"
end

def retrieve_name(language)
  name = ""
  loop do
    name = Kernel.gets().chomp().strip().capitalize()
    if !(validate_name?(name))
      prompt(messages('validate_name', language))
    else
      break
    end
  end
  name
end

def validate_name?(name_str)
  !(name_str.empty?) && \
    (/^[a-zA-ZŒÂÊÁËÈØÅÍÎÏÌÓÔÒÚÆŸÛÙÇ]\p{L}+$/.match(name_str) \
    || /^\p{L}[a-zA-ZŒÂÊÁËÈØÅÍÎÏÌÓÔÒÚÆŸÛÙÇÊ]+$/.match(name_str))
end

def validate_exit?(choice, language)
  if language == 'en'
    choice_format = %w(y n)
    choice_format.include?(choice)
  end
end

prompt(messages('welcome', language))
name = retrieve_name(language)
prompt(messages('greet', language) % { name_param: name })

def retrieve_loan_amount(language)
  loan_amount = ''
  loop do
    prompt(messages('loan_amount', language))
    loan_amount = Kernel.gets().chomp().strip()

    if validate_number?(loan_amount) && loan_amount.to_i >= 500 \
      && loan_amount > '0'
      break
    elsif !validate_number?(loan_amount)
      prompt(messages('invalid_number', language))
    else
      prompt(messages('min_amount', language))
    end
  end
  loan_amount
end

def retrieve_inter_rate(language)
  interest_rate = ''

  loop do
    prompt(messages('interest_rate', language))
    prompt(messages('example', language))
    interest_rate = Kernel.gets().chomp().strip()

    if validate_number?(interest_rate) && interest_rate.to_f > 0 \
      && interest_rate.to_f <= 50
      break
    elsif !validate_number?(interest_rate)
      prompt(messages('invalid_rate', language))
    end
  end
  interest_rate
end

def retrieve_duration(language)
  loan_duration = ''
  loop do
    prompt(messages('loan_entry', language))
    loan_duration = Kernel.gets().chomp().strip()

    if validate_number?(loan_duration) && loan_duration.to_i <= 20 \
      && loan_duration.to_i > 0
      break
    elsif loan_duration.to_i == 0
      prompt(messages('zero_entry', language))
    else
      prompt(messages('max_period', language))
    end
  end
  loan_duration
end

def try_again(language)
  continue = ""
  loop do
    prompt(messages('try_again', language))
    continue = Kernel.gets().chomp().downcase().strip()
    break if validate_exit?(continue, language)
  end
  continue
end

loop do # main loop
  loan_amount = retrieve_loan_amount(language).to_f
  interest_rate = retrieve_inter_rate(language).to_f
  loan_duration = retrieve_duration(language).to_i

  annual_interest_rate = interest_rate / 100
  month_interest_rate = annual_interest_rate / 12
  amount_in_months =  loan_duration * 12

  monthly_payments = loan_amount * (month_interest_rate / \
                                  (1 - (1 + month_interest_rate)**\
                                  (- amount_in_months)))

  prompt(messages('instalment', language), format('%0.2f', monthly_payments))

  continue = try_again(language)
  break if continue == 'n'
end

prompt(messages('farewell', language))
sleep(0.7)
Gem.win_platform? ? (system "cls") : (system "clear") # for Windows and Unix.

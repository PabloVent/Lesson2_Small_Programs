require 'yaml'
require 'pry'

language = 'en'

MESSAGES = YAML.load_file('calculator_messages.yml')

def messages(message, lang='en')
  MESSAGES[lang][message]
end

def prompt(msg, msg2=nil)
  Kernel.puts "=> #{msg} #{msg2}"
end

def valid_number?(input)
  integer?(input) || float?(input)
end

def integer?(input)
  /^-?\d+(\.\d+)?$/.match(input)
end

def float?(input)
  /\d/.match(input) && /^-\d*\.?\d*$/.match(input)
end

def operation_to_message(op)
  op_selected = case op
                when '1' then 'Adding'
                when '2' then 'Subtracting'
                when '3' then 'Multiplying'
                when '4' then 'Dividing'
                end
  op_selected
end
# prompt(MESSAGES['welcome'])
prompt(messages('lang', language))

language_choice = ""
loop do
  language_choice = Kernel.gets().chomp()
  if language_choice.downcase == 'en'
    language
  else
    language = 'is'
  end
  break
end

prompt(messages('welcome', language))

name = ""
loop do
  name = Kernel.gets().chomp()
  if name.empty?
    # prompt(MESSAGES['valid_name'])
    prompt(messages('valid_name', language))
  else
    break
  end
end

# prompt(MESSAGES['greet'] % { name_param: name })
# prompt(messages('greet', LANGUAGE))
prompt(MESSAGES[language]['greet'] % { name_param: name })

loop do # main loop
  first_num = ''
  loop do
    # prompt(MESSAGES['first_number'])
    prompt(messages('first_number', language))
    first_num = Kernel.gets().chomp()

    if valid_number?(first_num)
      break
    else
      # prompt(MESSAGES['invalid_number'])
      prompt(messages('invalid_number', language))
    end
  end

  second_num = ''
  loop do
    # prompt(MESSAGES['second_number'])
    prompt(messages('second_number', language))
    second_num = Kernel.gets().chomp()

    if valid_number?(second_num)
      break
    else
      # prompt(MESSAGES['invalid_number'])
      prompt(messages('invalid_number', language))
    end
  end

  if language == 'en'
    operator_prompt = <<-MSG
      What operation would you like to perform?
      1) add
      2) subtract
      3) multiply
      4) divide
    MSG
  elsif language == 'is'
    operator_prompt = <<-MSG
      Hvaða aðgerð myndir þú vilja framkvæma?
        1) viðbót
        2) frádráttur
        3) margföldun
        4) deild
    MSG
  end

  prompt(operator_prompt)

  operation = ''
  loop do
    operation = Kernel.gets().chomp()
    if %w(1 2 3 4).include?(operation)
      break
    else
      # prompt(MESSAGES['choose_one_option'])
      prompt(messages('choose_one_option', language))
    end
  end

  # prompt(MESSAGES [LANGUAGE] ['op_to_msg'] % { name_param: op_selected })
  # prompt(messages('op_to_msg' % \
  # { name_param: operation_to_message(operation) }, LANGUAGE))
  # puts "#{operation_to_message(operation)}"
  prompt(operation_to_message(operation), messages('op_to_msg', language))
  # prompt(messages('op_to_msg', LANGUAGE))

  result = case operation
           when '1' then first_num.to_i() + second_num.to_i()
           when '2' then first_num.to_i() - second_num.to_i()
           when '3' then first_num.to_i() * second_num.to_i()
           when '4' then first_num.to_f() / second_num.to_f()
           end

  # prompt(MESSAGES['result'] % { name_param: result })
  # prompt(messages("The result is #{result}")
  prompt("The result is #{result}") if language == 'en'
  prompt("Niðurstaðan er #{result}") if language == 'is'
  prompt(messages('continue', language))

  continue = Kernel.gets().chomp()
  break unless continue.downcase().start_with?('y')
end

prompt("Thanks for using calculator, goodbye!!!") if language == 'en'
prompt("Takk fyrir að nota reiknivél, bless!!!") if language == 'is'

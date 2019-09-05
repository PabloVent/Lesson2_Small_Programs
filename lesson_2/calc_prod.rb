require 'yaml'
require 'pry'

LANGUAGE = 'en'

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
prompt(messages('welcome', LANGUAGE))

name = ""
loop do
  name = Kernel.gets().chomp()
  if name.empty?
    prompt(messages('valid_name', LANGUAGE))
  else
    break
  end
end

prompt(MESSAGES[LANGUAGE]['greet'] % { name_param: name })

loop do # main loop
  first_num = ''
  loop do
    prompt(messages('first_number', LANGUAGE))
    first_num = Kernel.gets().chomp()

    if valid_number?(first_num)
      break
    else
      prompt(messages('invalid_number', LANGUAGE))
    end
  end

  second_num = ''
  loop do
    prompt(messages('second_number', LANGUAGE))
    second_num = Kernel.gets().chomp()

    if valid_number?(second_num)
      break
    else
      prompt(messages('invalid_number', LANGUAGE))
    end
  end

  operator_prompt = <<-MSG
    What operation would you like to perform?
    1) add
    2) subtract
    3) multiply
    4) divide
  MSG

  prompt(operator_prompt)

  operation = ''
  loop do
    operation = Kernel.gets().chomp()
    if %w(1 2 3 4).include?(operation)
      break
    else
      prompt(MESSAGES['choose_one_option'])
      prompt(messages('choose_one_option', LANGUAGE))
    end
  end

  prompt(operation_to_message(operation), messages('op_to_msg', LANGUAGE))

  result = case operation
           when '1' then first_num.to_i() + second_num.to_i()
           when '2' then first_num.to_i() - second_num.to_i()
           when '3' then first_num.to_i() * second_num.to_i()
           when '4' then first_num.to_f() / second_num.to_f()
           end

  prompt("The result is #{result}")
  prompt(messages('continue', LANGUAGE))

  continue = Kernel.gets().chomp()
  break unless continue.downcase().start_with?('y')
end

prompt("Thanks for using calculator, goodbye!!!")

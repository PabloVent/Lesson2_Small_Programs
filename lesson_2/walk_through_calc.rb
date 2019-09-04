require 'yaml'

LANGUAGE = 'en'

MESSAGES = YAML.load_file('calculator_messages.yml')

def messages(message, lang='en')
  MESSAGES[lang][message]
end

def prompt(msg)
  Kernel.puts "=> #{msg}"
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

def operation_to_message(op) # returns result of case statement
  op_selected = case op
                when '1' then 'Adding'
                when '2' then 'Subtracting'
                when '3' then 'Multiplying'
                when '4' then 'Dividing'
                end
  op_selected
end

prompt(MESSAGES['welcome'])
# prompt(messages('welcome', LANGUAGE))

name = ""
loop do
  name = Kernel.gets().chomp()
  if name.empty?
    prompt(MESSAGES['valid_name'])
    # prompt(messages('valid_name'), LANGUAGE)
  else
    break
  end
end

# prompt("Hi #{name}")
prompt(MESSAGES["greet"] % { name_param: name })
# prompt(messages('greet', LANGUAGE))

loop do # main loop
  first_num = ''
  loop do
    prompt(MESSAGES['first_number'])
    first_num = Kernel.gets().chomp()

    if valid_number?(first_num)
      break
    else
      prompt(MESSAGES['invalid_number'])
    end
  end

  second_num = ''
  loop do
    prompt(MESSAGES['second_number'])
    second_num = Kernel.gets().chomp()

    if valid_number?(second_num)
      break
    else
      prompt(MESSAGES['invalid_number'])
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
    end
  end

  # prompt("#{operation_to_message(operation)} the two numbers...")
  prompt(MESSAGES['op_to_msg'] % \
    { name_param: operation_to_message(operation) })

  result = case operation
           when '1' then first_num.to_i() + second_num.to_i()
           when '2' then first_num.to_i() - second_num.to_i()
           when '3' then first_num.to_i() * second_num.to_i()
           when '4' then first_num.to_f() / second_num.to_f()
           end
  # prompt("The result is #{result}")
  prompt(MESSAGES['result'] % { name_param: result })
  prompt(MESSAGES['continue'])

  continue = Kernel.gets().chomp()
  break unless continue.downcase().start_with?('y')
end

prompt("Thanks for using calculator, goodbye!!!")

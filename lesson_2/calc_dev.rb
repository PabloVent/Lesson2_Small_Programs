require 'yaml'
require 'pry'

language = "en"

MESSAGES = YAML.load_file('calc_messages.yml')

def messages(message, lang='en')
  MESSAGES[lang][message]
end

def prompt(msg, msg2=nil)
  Kernel.puts "=> #{msg} #{msg2}"
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

def validate_lang?(language_choice)
  lang_format = %w(en is)
  lang_format.include?(language_choice)
end

def validate_exit?(choice)
  choice_format = %w(y n)
  choice_format.include?(choice)
end

def validate_name?(name_str)
  /^[a-zA-ZŒÂÊÁËÈØÅÍÎÏÌÓÔÒÚÆŸÛÙÇ]\p{L}+$/.match(name_str) \
  || /^\p{L}[a-zA-ZŒÂÊÁËÈØÅÍÎÏÌÓÔÒÚÆŸÛÙÇÊ]+$/.match(name_str) \
end

def retrieve_language_choice(language, language_choice="")
  loop do
    language_choice = Kernel.gets().chomp().downcase().strip()
    if language_choice.empty? || !(validate_lang?(language_choice))
      prompt(messages('validate_lang', language))
      next
    elsif language_choice == language
      language
    else
      language = 'is'
    end
    break if language == 'en' || language == 'is'
  end
  language
end

name = ""
def retrieve_name(name, language)
  loop do
    name = Kernel.gets().chomp().capitalize().strip()
    if name.empty? || !(validate_name?(name))
      # prompt(MESSAGES['validate_name'])
      prompt(messages('validate_name', language))
    else
      break
    end
  end
  name
end

def op_to_ms(op, lang='en')
  op_selected = case op
                when '1' then messages('option1', lang)
                when '2' then messages('option2', lang)
                when '3' then messages('option3', lang)
                when '4' then messages('option4', lang)
                end
  op_selected
end
# prompt(MESSAGES['welcome'])
prompt(messages('lang_option', language))

language = retrieve_language_choice(language)
prompt(messages('welcome', language))

# name = ""
# loop do
#   name = Kernel.gets().chomp().capitalize().strip()
#   if name.empty? || !(validate_name?(name))
#     # prompt(MESSAGES['validate_name'])
#     prompt(messages('validate_name', language))
#   else
#     break
#   end
# end

name = retrieve_name(name, language)

# prompt(MESSAGES['greet'] % { name_param: name })
# prompt(messages('greet', LANGUAGE))
prompt(MESSAGES[language]['greet'] % { name_param: name })

loop do # main loop
  first_num = ''

  loop do
    # prompt(MESSAGES['first_number'])
    prompt(messages('first_number', language))
    first_num = Kernel.gets().chomp().strip()

    if validate_number?(first_num)
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
    second_num = Kernel.gets().chomp().strip()

    if validate_number?(second_num) && second_num != '0'
      break
    elsif !validate_number?(second_num)
      prompt(messages('invalid_number', language))
    else
      prompt(messages('zero_division', language))
    end
  end

  prompt(messages('operation', language))
  # prompt(operator_prompt)

  operation = ''
  loop do
    operation = Kernel.gets().chomp().strip()
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
  prompt(op_to_ms(operation, language), messages('op_to_ms', language))

  result = case operation
           when '1' then first_num.to_i() + second_num.to_i()
           when '2' then first_num.to_i() - second_num.to_i()
           when '3' then first_num.to_i() * second_num.to_i()
           when '4' then first_num.to_f() / second_num.to_f()
           end

  # prompt(MESSAGES['result'] % { name_param: result })
  # prompt(messages("The result is #{result}")
  # prompt("The result is #{result}") if language == 'en'
  prompt(MESSAGES[language]['result'] % { name_param: result })

  continue = ""
  loop do
    prompt(messages('carry_on', language))
    continue = Kernel.gets().chomp().downcase().strip()
    break if validate_exit?(continue)
  end
  break if continue == 'n'
end

prompt(messages('farewell', language))

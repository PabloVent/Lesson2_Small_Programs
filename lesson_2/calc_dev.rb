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

def valid_lang?(lang_format)
  /^[en]+$/.match(lang_format) || /^[is]+$/.match(lang_format)
end

def validate_name?(name_str)
  /^[a-zA-ZŒÂÊÁËÈØÅÍÎÏÌÓÔÒÚÆŸÛÙÇ]\p{L}+$/.match(name_str) \
  || /^\p{L}[a-zA-ZŒÂÊÁËÈØÅÍÎÏÌÓÔÒÚÆŸÛÙÇÊ]+$/.match(name_str) \
  || /^[\p{Arabic}\s\p{N}]+$/.match(name_str) || /[\p{Cyrillic}]/.match(name_str) #\
  #|| /^[α-ωΑ-Ω\s]*$/
end

# rubocop:disable Metrics/CyclomaticComplexity
def op_to_ms(op, lang='en')
  if lang == 'en'
    op_selected = case op
                  when '1' then 'Adding'
                  when '2' then 'Subtracting'
                  when '3' then 'Multiplying'
                  when '4' then 'Dividing'
                  end
  else
    op_selected = case op
                  when '1' then 'Bæta við'
                  when '2' then 'Draga frá'
                  when '3' then 'Fjölga sér'
                  when '4' then 'Skipting'
                  end
  end
  op_selected
end
# rubocop:enable Metrics/CyclomaticComplexity

# prompt(MESSAGES['welcome'])
prompt(messages('lang_option', language))

language_choice = ""
loop do
  language_choice = Kernel.gets().chomp().downcase().strip()
  if language_choice.empty? || !(valid_lang?(language_choice))
    prompt(messages('valid_lang', language))
    next
  elsif valid_lang?(language_choice) && language_choice == language
    language
  elsif valid_lang?(language_choice) && language_choice != language
    language = 'is'
  end
  break if language == 'en' || language == 'is'
end
prompt(messages('welcome', language))

name = ""
loop do
  name = Kernel.gets().chomp().strip()
  if name.empty? || !(validate_name?(name))
    # prompt(MESSAGES['validate_name'])
    prompt(messages('validate_name', language))
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
    first_num = Kernel.gets().chomp().strip()

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
    second_num = Kernel.gets().chomp().strip()

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
  # prompt(messages('op_to_msg', LANGUAGE))

  result = case operation
           when '1' then first_num.to_i() + second_num.to_i()
           when '2' then first_num.to_i() - second_num.to_i()
           when '3' then first_num.to_i() * second_num.to_i()
           when '4' then first_num.to_f() / second_num.to_f()
           end

  # prompt(MESSAGES['result'] % { name_param: result })
  # prompt(messages("The result is #{result}")
  # prompt("The result is #{result}") if language == 'en'
  # prompt("Niðurstaðan er #{result}") if language == 'is'
  prompt(MESSAGES[language]['result'] % { name_param: result })

  prompt(messages('continue', language))

  continue = Kernel.gets().chomp().strip()
  break if continue.downcase().start_with?('n') && language == 'en' \
  || continue.downcase().start_with?('n') && language == 'is'
end

prompt(messages('farewell', language))

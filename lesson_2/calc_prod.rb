require 'yaml'

language = 'en'

MESSAGES = YAML.load_file('calculator_messages.yml')

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

def validate_lang?(lang_format)
  /^[en]+$/.match(lang_format) || /^[is]+$/.match(lang_format)
end

def validate_name?(name_str)
  /^[a-zA-ZŒÂÊÁËÈØÅÍÎÏÌÓÔÒÚÆŸÛÙÇ]\p{L}+$/.match(name_str) \
  || /^\p{L}[a-zA-ZŒÂÊÁËÈØÅÍÎÏÌÓÔÒÚÆŸÛÙÇÊ]+$/.match(name_str) \
  || /^[\p{Arabic}\s\p{N}]+$/.match(name_str) \
  || /[\p{Cyrillic}]/.match(name_str)
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
prompt(messages('lang_option', language))

language_choice = ""
loop do
  language_choice = Kernel.gets().chomp().downcase().strip()
  if language_choice.empty? || !(validate_lang?(language_choice))
    prompt(messages('validate_lang', language))
    next
  elsif validate_lang?(language_choice) && language_choice == language
    language
  elsif validate_lang?(language_choice) && language_choice != language
    language = 'is'
  end
  break if language == 'en' || language == 'is'
end
prompt(messages('welcome', language))

name = ""
loop do
  name = Kernel.gets().chomp().capitalize().strip()
  if name.empty? || !(validate_name?(name))
    prompt(messages('validate_name', language))
  else
    break
  end
end

prompt(MESSAGES[language]['greet'] % { name_param: name })

loop do # main loop
  first_num = ''
  loop do
    prompt(messages('first_number', language))
    first_num = Kernel.gets().chomp().strip()

    if validate_number?(first_num)
      break
    else
      prompt(messages('invalid_number', language))
    end
  end

  second_num = ''
  loop do
    prompt(messages('second_number', language))
    second_num = Kernel.gets().chomp().strip()

    if validate_number?(second_num)
      break
    else
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
      prompt(messages('choose_one_option', language))
    end
  end

  prompt(op_to_ms(operation, language), messages('op_to_ms', language))

  result = case operation
           when '1' then first_num.to_i() + second_num.to_f()
           when '2' then first_num.to_i() - second_num.to_f()
           when '3' then first_num.to_i() * second_num.to_f()
           when '4' then first_num.to_f() / second_num.to_f()
           end

  prompt(MESSAGES[language]['result'] % { name_param: result })
  prompt(messages('carry_on', language))

  continue = Kernel.gets().chomp().strip()
  break if continue.downcase().start_with?('n') && language == 'en' \
  || continue.downcase().start_with?('n') && language == 'is'
end

prompt(messages('farewell', language))

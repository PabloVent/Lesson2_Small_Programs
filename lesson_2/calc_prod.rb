require 'yaml'

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

def validate_exit?(choice, language)
  if language == 'en'
    choice_format = %w(y n)
    choice_format.include?(choice)
  elsif language == 'is'
    choice_format2 = %w(j n)
    choice_format2.include?(choice)
  end
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

def retrieve_name(language)
  name = ""
  loop do
    name = Kernel.gets().chomp().capitalize().strip()
    if name.empty? || !(validate_name?(name))
      prompt(messages('validate_name', language))
    else
      break
    end
  end
  name
end

def op_to_ms(op, lang='en')
  op_selected = case op
                when '1' then messages('option1', lang) # adding
                when '2' then messages('option2', lang)
                when '3' then messages('option3', lang)
                when '4' then messages('option4', lang)
                end
  op_selected
end

prompt(messages('lang_option', language))

language = retrieve_language_choice(language)
prompt(messages('welcome', language))

name = retrieve_name(language)
# prompt(MESSAGES[language]['greet'] % { name_param: name })
prompt(messages('greet', language) % { name_param: name })

loop do # main loop
  def retrieve_num1(language)
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
    first_num
  end
  first_num = retrieve_num1(language)

  def retrieve_num2(language)
    second_num = ''
    loop do
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
    second_num
  end
  second_num = retrieve_num2(language)

  prompt(messages('operation', language))

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
           when '1' then first_num.to_i() + second_num.to_i()
           when '2' then first_num.to_i() - second_num.to_i()
           when '3' then first_num.to_i() * second_num.to_i()
           when '4' then first_num.to_f() / second_num.to_f()
           end

  prompt(MESSAGES[language]['result'] % { name_param: result })

  def try_again(language)
    continue = ""
    loop do
      prompt(messages('carry_on', language))
      continue = Kernel.gets().chomp().downcase().strip()
      break if validate_exit?(continue, language)
    end
    continue
  end
  continue = try_again(language)

  break if continue == 'n'
  next if continue == 'y'
end

prompt(messages('farewell', language))

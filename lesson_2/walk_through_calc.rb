# Ask the user for 2 numbers.
# Ask for the type of operation to perform: Add, subtract, multiply or divide.
# perform the operation selected.
# display the result.
def prompt(msg)
  Kernel.puts "=> #{msg}"
end

def valid_number?(num)
  num.to_i() != 0
end

def operation_to_message(op) # returns result of case statement
  case op
  when '1' then 'Adding'
  when '2' then 'Subtracting'
  when '3' then 'Multiplying'
  when '4' then 'Dividing'
  end
end

prompt("Welcome to calculator!! Enter your name:")

name = ""
loop do
  name = Kernel.gets().chomp()
  if name.empty?
    prompt("Make sure you enter your name please...")
  else
    break
  end
end

prompt("Hi #{name}")

loop do # main loop
  first_num = ''
  loop do
    prompt("What's your 1st number...")
    first_num = Kernel.gets().chomp()

    if valid_number?(first_num)
      break
    else
      prompt("ups...looks like that's not a valid number...")
    end
  end

  second_num = ''
  loop do
    prompt("What's your 2st number...")
    second_num = Kernel.gets().chomp()

    if valid_number?(second_num)
      break
    else
      prompt("mmm, not a valid number, try again...")
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
      prompt("You must choose 1, 2, 3 or 4...")
    end
  end

  prompt("#{operation_to_message(operation)} the two numbers...")

  result = case operation
           when '1' then first_num.to_i() + second_num.to_i()
           when '2' then first_num.to_i() - second_num.to_i()
           when '3' then first_num.to_i() * second_num.to_i()
           when '4' then first_num.to_f() / second_num.to_f()
           end

  prompt("The result is #{result}")
  prompt("do you want to perform another operation?, say 'Y' if yes...")
  continue = Kernel.gets().chomp()
  break unless continue.downcase().start_with?('y')
end

prompt("Thanks for using calculator, goodbye!!!")

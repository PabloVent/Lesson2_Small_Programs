# Ask the user for 2 numbers.
# Ask for the type of operation to perform: Add, subtract, multiply or divide.
# perform the operation selected.
# display the result.

Kernel.puts("Welcome to calculator!!")

Kernel.puts("What's your 1st number...")
first_num = Kernel.gets().chomp()

Kernel.puts("What's your 2nd one...")
second_num = Kernel.gets().chomp()

Kernel.puts("What operation would you lioke to perform? 1) add, 2) subtract, 3) multiply, 4) divide")
operation = Kernel.gets().chomp()

if operation == '1'
  result = first_num.to_i() + second_num.to_i()
elsif operation == '2'
    result = first_num.to_i() - second_num.to_i()
  elsif operation == '3'
      result = first_num.to_i() * second_num.to_i()
    else
      result = first_num.to_f() / second_num.to_f()
end

Kernel.puts("The result is #{result}")
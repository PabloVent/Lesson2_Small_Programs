require 'pry'

VALID_CHOICES = ['rock', 'paper', 'scissors']

def prompt(message)
  Kernel.puts("=> #{message}")
end

def win?(first, second)
  (first == 'rock' && second == 'scissors') \
    || (first == 'scissors' && second == 'paper') \
    || (first == 'paper' && second == 'rock')
end

def display_results(player, computer)
  if win?(player, computer)
    prompt("You won.")
  elsif win?(computer, player)
    prompt("computer won.")
  else
    prompt("It's a tie.")
  end
end

def validate_choice(choice_input)
  choice = ""
  loop do
    prompt("Choose one: #{VALID_CHOICES.join(', ')}")
    choice = Kernel.gets().chomp()

    if VALID_CHOICES.include?(choice)
      break
    else
      prompt("That's not valid choice.")
    end
  end
  choice
end

loop do
  choice = validate_choice(choice)
  computer_choice = VALID_CHOICES.sample

  prompt("You chose: '#{choice}' and computer chose '#{computer_choice}'")

  display_results(choice, computer_choice)

  prompt('Do you want to play again?')
  answer = Kernel.gets().chomp()
  break unless answer.start_with?('y')
end

prompt("Thanks for playing. So long.")

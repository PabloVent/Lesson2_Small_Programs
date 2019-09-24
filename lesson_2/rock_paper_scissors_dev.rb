require 'pry'

VALID_CHOICES = ['rock', 'paper', 'scissors']

def prompt(message)
  Kernel.puts("=> #{message}")
end

def self_win(player, computer)
  if (player == 'rock' && computer == 'scissors') \
    || (player == 'scissors' && computer == 'paper') \
    || (player == 'paper' && computer == 'rock')
    true
  end
end

def computer_win(player, computer)
  if (computer == 'rock' && player == 'scissors') \
    || (computer == 'scissors' && player == 'paper') \
    || (computer == 'paper' && player == 'rock')
    true
  end
end

def tie(player, computer)
  if self_win(player, computer) && computer_win(player, computer)
    true
  end
end

def display_results(player, computer)
  if self_win(player, computer)
    prompt("You won.")
  elsif computer_win(player, computer)
    prompt("computer won.")
  else
    prompt("It's a tie.")
  end
end

loop do
  choice = ''
  loop do
    prompt("Choose one: #{VALID_CHOICES.join(', ')}")
    choice = Kernel.gets().chomp()

    if VALID_CHOICES.include?(choice)
      break
    else
      prompt("That's not valid choice.")
    end
  end

  computer_choice = VALID_CHOICES.sample

  prompt("You chose: '#{choice}' and computer chose '#{computer_choice}'")

  display_results(choice, computer_choice)

  prompt('Do you want to play again?')
  answer = Kernel.gets().chomp()
  break unless answer.start_with?('y')
end

prompt("Thanks for playing. So long.")

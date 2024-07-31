require_relative "game"
require_relative "displayable"

puts "Welcome to Hangman! Would you like to start a new game or continue from where you left?"
puts "1 => New Game\n2 => Load Game"
user_choice = gets.chomp.to_i
until [1, 2].include?(user_choice)
  puts "Not an option."
  user_choice = gets.chomp.to_i
end
if user_choice == 1
  Game.new.start_game
elsif user_choice == 2
  game = Game.load_game
  game.continue_last_round
end

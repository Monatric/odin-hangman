require_relative "game"

puts "Welcome to Hangman! Would you like to start a new game or continue from where you left?"
puts "1 => New Game\n2 => Load Game"
user_choice = gets.chomp.to_i
if user_choice == 1
  Game.new.start_game
elsif user_choice == 2
  Game.new.load_game
else
  puts "Not an option."
end

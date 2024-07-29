# game
class Game
  def initialize
    dictionary = File.readlines("dictionary.txt")
    secret_word = dictionary.select do |element|
      element.chomp.length > 5 && element.chomp.length < 12
    end.sample

    puts secret_word
  end
end

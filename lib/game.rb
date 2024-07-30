# game
class Game
  def initialize
    @dictionary = File.readlines("dictionary.txt")
    @secret_word = dictionary.select do |element|
      element.chomp.length > 5 && element.chomp.length < 12
    end.sample.chomp
    @secret_word_blank = []
    @secret_word_reference = secret_word.chars
    @guess = []
    @attempts = 8

    p secret_word_reference
    puts secret_word
    start_game
  end

  attr_reader :secret_word, :guess, :secret_word_blank, :dictionary, :secret_word_reference

  def start_game
    puts "Welcome! Try to guess the word."
    set_up_interface
    user_guess = gets.chomp
    is_correct = false
    secret_word_reference.each_with_index do |element, index|
      if user_guess == element
        secret_word_blank[index] = user_guess
        is_correct = true
      elsif secret_word_reference.size - 1 == index && is_correct == false
        puts "Letter does not exist! Try again."
      end
    end
  end

  def set_up_interface
    secret_word.length.times do |n|
      secret_word_blank.push("⎯")
    end
    secret_word_blank.each_with_index do |element, index|
      print "#{element} "
      puts "\nEnter a letter for your guess.\n" if secret_word_blank.size - 1 == index
    end
  end
end

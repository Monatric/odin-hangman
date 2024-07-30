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
    @is_finished = false

    p secret_word_reference
    puts secret_word
    start_game
  end

  attr_accessor :is_finished
  attr_reader :secret_word, :guess, :secret_word_blank, :dictionary, :secret_word_reference

  def start_game
    puts "Welcome! Try to guess the word."
    set_up_interface
    until is_finished == true
      take_user_guess
      display_missing_word
    end
  end

  def take_user_guess
    user_guess = gets.chomp
    until user_guess.match?(/^[A-Za-z]+$/)
      puts "That's not a letter."
      user_guess = gets.chomp
    end
    insert_letter(user_guess)
  end

  def insert_letter(user_guess)
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
    secret_word.length.times do
      secret_word_blank.push("⎯")
    end
    display_missing_word
  end

  def display_missing_word
    secret_word_blank.each_with_index do |element, index|
      print "#{element} "
      puts "\nEnter a letter for your guess.\n" if secret_word_blank.size - 1 == index
    end
  end
end

require "pry-byebug"
require "yaml"
require_relative "displayable"

# game
class Game
  include Displayable

  DICTIONARY = File.readlines("dictionary.txt")

  def initialize
    @secret_word = DICTIONARY.select do |element|
      element.chomp.length > 5 && element.chomp.length < 12
    end.sample.chomp
    @secret_word_blank = []
    @secret_word_reference = secret_word.chars
    @guess = []
    @attempts = 8
    @chosen_letters = []
    @is_finished = false
  end

  def start_game
    display_welcome
    set_up_interface
    continue_round
  end

  def self.load_game
    YAML.load_file("saved_file.yml", permitted_classes: [Game, Symbol])

    # display_missing_word(secret_word_blank)
    # continue_round
  end

  def continue_last_round
    display_missing_word(secret_word_blank)
    continue_round
  end

  def continue_round
    until is_finished == true
      check_winner

      take_user_guess
      display_missing_word(secret_word_blank)
    end
  end

  private

  attr_accessor :is_finished, :attempts, :secret_word, :secret_word_blank, :dictionary, :secret_word_reference,
                :chosen_letters

  def save_game
    yaml = YAML.dump(self, permitted_classes: [Game])
    File.write("saved_file.yml", yaml)
    puts "Thanks for playing! Come again next time."
    exit
  end

  def check_winner
    if secret_word_blank == secret_word_reference
      puts "The word is #{secret_word}"
      puts "Winner!"
      self.is_finished = true
    elsif attempts.zero?
      puts "The word is #{secret_word}"
      puts "LOser"
      self.is_finished = true
    end
    is_finished == true
  end

  def take_user_guess
    user_guess = gets.chomp.downcase
    save_game if user_guess == "1"

    validate_user_guess(user_guess)

    chosen_letters << user_guess
    insert_letter(user_guess)
  end

  def validate_user_guess(user_guess)
    until user_guess.match?(/^[A-Za-z]+$/)
      puts "That's not a letter."
      user_guess = gets.chomp.downcase
    end

    while chosen_letters.include?(user_guess)
      print "Already chosen. Try another letter: "
      user_guess = gets.chomp.downcase
    end
  end

  def insert_letter(user_guess)
    is_correct = false
    secret_word_reference.each_with_index do |element, index|
      if user_guess == element
        secret_word_blank[index] = user_guess
        is_correct = true
      elsif secret_word_reference.size - 1 == index && is_correct == false
        self.attempts -= 1
        break if attempts.zero?

        display_attempts
      end
    end
  end

  def set_up_interface
    secret_word.length.times do
      secret_word_blank.push("⎯")
    end
    display_missing_word(secret_word_blank)
  end
end

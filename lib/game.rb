require "pry-byebug"
require "yaml"

# game
class Game
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
    puts "Welcome! Try to guess the word."
    set_up_interface
    until is_finished == true
      check_winner

      take_user_guess
      display_missing_word
    end
  end

  def load_game
    data = YAML.load_file("saved_file.yml")
    self.secret_word = data[:secret_word]
    self.secret_word_blank = data[:secret_word_blank]
    self.secret_word_reference = data[:secret_word_reference]
    self.guess = data[:guess]
    self.attempts = data[:attempts]
    self.chosen_letters = data[:chosen_letters]
    self.is_finished = data[:is_finished]
    display_missing_word

    until is_finished == true
      check_winner

      take_user_guess
      display_missing_word
    end
  end

  private

  attr_accessor :is_finished, :attempts, :secret_word, :guess, :secret_word_blank, :dictionary, :secret_word_reference,
                :chosen_letters

  def save_game
    yaml = YAML.dump({
                       secret_word: secret_word,
                       secret_word_blank: secret_word_blank,
                       secret_word_reference: secret_word_reference,
                       guess: guess,
                       attempts: attempts,
                       chosen_letters: chosen_letters,
                       is_finished: is_finished
                     })
    File.write("saved_file.yml", yaml)
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
    until user_guess.match?(/^[A-Za-z]+$/)
      puts "That's not a letter."
      user_guess = gets.chomp.downcase
    end

    while chosen_letters.include?(user_guess)
      print "Already chosen. Try another letter: "
      user_guess = gets.chomp.downcase
    end

    chosen_letters << user_guess
    insert_letter(user_guess)
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
    display_missing_word
  end

  def display_missing_word
    puts "\n"
    secret_word_blank.each_with_index do |element, index|
      break if check_winner == true

      print "#{element} "

      if secret_word_blank.size - 1 == index
        puts "\n\n[Enter '1' to save your game.]"
        print "Enter a letter for your guess: "
      end
    end
  end

  def display_attempts
    puts "Letter does not exist! Try again.\tAttempts left: #{attempts}"
  end
end

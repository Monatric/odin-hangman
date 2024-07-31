module Displayable
  def display_welcome
    puts "Welcome! Try to guess the word."
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

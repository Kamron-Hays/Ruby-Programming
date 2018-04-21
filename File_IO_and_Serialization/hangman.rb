class Hangman
  def initialize
    @max_misses = 9
    @word = nil
    @words = []
    File.open("5desk.txt").each do |line|
      # remove all spaces and newlines from beginning and end
      word = line.strip
      # use only words that are 5-12 letters in length and aren't proper nouns
      @words << word if word.length.between?(5, 12) && word[0] != word[0].upcase
    end
  end

  def display_game
    print "\033[2;1H" # move cursor to line 2, column 1

    case @misses
    when 1
      @gallows[0][9] = '┓'
    when 2
      @gallows[1][9] = '┃'
    when 3
      @gallows[2][9] = 'O'
    when 4
      @gallows[3][9] = '|'
    when 5
      @gallows[3][8] = '/'
    when 6
      @gallows[3][10] = '\\'
    when 7
      @gallows[4][9] = '|'
    when 8
      @gallows[5][8] = '/'
    when 9
      @gallows[5][10] = '\\'
    end

    @gallows.each { |line| puts line }

    puts "\nWord: #{@correct}\n" +
          "\n" +
          "Misses: #{@incorrect}\n\n"

    done = win_or_lose
    print "Enter your guess: " if !done
    done
  end

  def check_guess(letter)
    found = false
    @word.each_char.with_index do |ch, i|
			if ch == letter
				@correct[i*2] = letter
        found = true
			end
		end
    
    if !found
      @incorrect[@misses*2] = letter
      @misses += 1
    end
  end

  def process_input
    message = nil
    print "\033[0K" # erase to end of line (the previous guess/command)
    input = gets.chomp.downcase

		# If user wants to save, save game
		if input == "load"
			# load game
    elsif input == "save"
      # save game
    elsif input.length > 1
      message = "Enter just one letter. Try again."
    elsif !input.match(/[[:alpha:]]/)
      message = "You must enter a letter. Try again!"
		elsif @correct.include?(input) || @incorrect.include?(input)
			message = "You guessed that letter already! Try again."
		else
      check_guess(input)
		end

    # clear previous message (if any)
    print "\033[2K"
    
    # display new message (if any)
    puts message if message
  end

  def win_or_lose
    message = nil
    if @misses >= @max_misses
      message = "You've been hung!\n" +
                "The word was #{@word}"
    elsif !@correct.include?("_")
      message = "You successfully avoided hanging!"
    end

    puts message if message
    message != nil
  end

  def play
    loop do
      if @word # if this is not the first time through
        print "Play again? [y|n]: "
        response = gets.chomp.downcase
        break if response != "y" && response != "ye" && response != "yes"
        # clear the "screen"
        print "\033[2J"
      end

      @gallows = [ "   ┏━━━━━   \n",
                   "   ┃        \n",
                   "   ┃        \n",
                   "   ┃        \n",
                   "   ┃        \n",
                   "   ┃        \n",
                   "   ┃        \n",
                   "   ┃        \n",
                   "  ━┻━━━━━━  \n" ]
      @misses = 0
      @word = @words[rand(@words.length)]
      @correct = ""
		  @word.length.times { @correct += "_ " }
      @incorrect = ""
		  @max_misses.times { @incorrect += "_ " }

      loop do
        done = display_game
        break if done
        process_input
      end
    end
  end
end

Hangman.new.play
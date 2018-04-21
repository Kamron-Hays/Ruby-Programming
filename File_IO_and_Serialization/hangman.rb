#!/usr/bin/env ruby

require 'yaml'

class Hangman

  SAVE_FILE = "./.hangman.yml"
  MAX_MISSES = 9

  # ANSI Control Sequences
  CLR_TO_EOS  = "\033[0J" # clear from cursor to end of screen
  CLR_TO_EOL  = "\033[0K" # clear from cursor to end of line
  CLR_LINE    = "\033[2K" # clear entire line
  CURSOR_HOME = "\033[2;1H" # move cursor to line 2, column 1

  def initialize(ansi_term = true)
    @ansi_term = ansi_term
    @word = nil
    @words = []
    File.open("5desk.txt").each do |line|
      # remove all spaces and newlines from beginning and end
      word = line.strip
      # use only words that are 5-12 letters in length and aren't proper nouns
      @words << word if word.length.between?(5, 12) && word[0] != word[0].upcase
    end

    if File.exists?(SAVE_FILE)
      @saved_games = YAML.load( File.open(SAVE_FILE, 'r') )
    else
      @saved_games = []
    end
    
    print CURSOR_HOME if @ansi_term
    print CLR_TO_EOS if @ansi_term
  end

  def play
    loop do
      if @word # if this is not the first time through
        print "Play again? [y|n]: "
        response = gets.chomp.downcase
        print CURSOR_HOME if @ansi_term
        print CLR_TO_EOS if @ansi_term
        break if response != "y" && response != "ye" && response != "yes"
      end

      init_game

      loop do
        done = display_game
        break if done
        process_input
      end
    end
  end

  protected

  def display_game
    print CLR_TO_EOS if @ansi_term
    print CURSOR_HOME if @ansi_term

    @gallows.each { |line| puts line }

    puts "\nWord: #{@correct}\n" +
          "\n" +
          "Misses: #{@incorrect}\n\n"

    done = win_or_lose
    print  "Enter 'load', 'save', 'quit', or\nEnter your guess: " if !done
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
      update_gallows
    end
  end

  def process_input
    message = nil
    print CLR_TO_EOL if @ansi_term
    input = gets.chomp.downcase

    if input == "load"
      message = load_game
    elsif input == "save"
      message = save_game
    elsif input == "quit"
      print CURSOR_HOME if @ansi_term
      print CLR_TO_EOS if @ansi_term
      exit
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
    print CLR_LINE if @ansi_term
    
    # display new message (if any)
    puts message if message
  end

  def win_or_lose
    message = nil
    if @misses >= MAX_MISSES
      message = "You've been hung!\n" +
                "The word was #{@word}"
    elsif !@correct.include?("_")
      message = "You successfully avoided hanging!"
    end

    if message
      print CLR_TO_EOS if @ansi_term
      puts message
    end
    message != nil
  end

  def init_game(game = nil)
    @gallows = [ "   +-----   \n",
                 "   |        \n",
                 "   |        \n",
                 "   |        \n",
                 "   |        \n",
                 "   |        \n",
                 "   |        \n",
                 "   |        \n",
                 "  -+------  \n" ]

    if !game
      @misses = 0
      @word = @words[rand(@words.length)]
      @correct = ""
      @word.length.times { @correct += "_ " }
      @incorrect = ""
      MAX_MISSES.times { @incorrect += "_ " }
    else
      @correct = game[0].dup
      @incorrect = game[1].dup
      @word = @words[game[2]]
      @misses = MAX_MISSES - @incorrect.count("_")
      @gallows[0][9] = '+'   if @misses >= 1
      @gallows[1][9] = '|'   if @misses >= 2
      @gallows[2][9] = 'O'   if @misses >= 3
      @gallows[3][9] = '|'   if @misses >= 4
      @gallows[3][8] = '/'   if @misses >= 5
      @gallows[3][10] = '\\' if @misses >= 6
      @gallows[4][9] = '|'   if @misses >= 7
      @gallows[5][8] = '/'   if @misses >= 8
      @gallows[5][10] = '\\' if @misses >= 9
    end
  end

  def save_game
    word_index = @words.index(@word)
    if !@saved_games.include?([ @correct, @incorrect, word_index ])
      @saved_games << [ @correct, @incorrect, word_index ]
      File.open(SAVE_FILE, 'w') do |file|
        file.puts YAML.dump(@saved_games)
      end
      message = "Saved game #{@correct}"
    else
      message = "Game already saved."
    end
    message
  end

  def load_game
    print CLR_TO_EOS if @ansi_term
    if @saved_games.length > 0
      @saved_games.each.with_index { |game, i| puts "#{i+1}. #{game[0]}" }
      
      while true
        print "Choose a game: "
        choice = gets.chomp.to_i
        if choice > 0 && choice <= @saved_games.length
          init_game(@saved_games[choice-1])
          print CURSOR_HOME if @ansi_term
          print CLR_TO_EOS if @ansi_term
          break
        else
          puts "Invalid choice. Try again."
        end
      end
    else
      message = "No saved games."
    end
  end

  def update_gallows
    case @misses
    when 1
      @gallows[0][9] = '+'
    when 2
      @gallows[1][9] = '|'
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
  end
end

if __FILE__ == $0
  # this will only run if the script was the main, not load'd or require'd
  Hangman.new.play
end
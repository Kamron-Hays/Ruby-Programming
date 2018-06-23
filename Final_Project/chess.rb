#!/usr/bin/env ruby

require_relative "player"
require_relative "board"
require 'yaml'
require 'fileutils'

class Chess

  @@SAVE_DIR = "./.chess"

  def initialize
    @side = nil
    @white = nil
    @black = nil
    @board = nil
    @done = false
    @game_over = false
    @skip_board_draw = false
    @saved_games = []

    if File.exist?(@@SAVE_DIR)
      Dir.entries(@@SAVE_DIR).each do |entry|
        m = entry.match(/\.([a-zA-Z_0-9]+)\.yml/)
        if m && m.size == 2
          @saved_games << m[1]
        end
      end
    end
    @saved_games.sort!
  end

  def display_board
    if !@skip_board_draw
      @board.draw
    end
    @skip_board_draw = false
  end

  def display_help
    puts "\nEnter start and end coordinates to move a piece (for example c2c4)\n" +
         "or one of the following commands:\n" +
         "\n" +
         "save   (save the state of the current game)\n" +
         "load   (load a previously saved game)\n" +
         "resign (admit defeat)\n" +
         "help   (displays this message)\n" +
         "exit   (terminate the game, losing any unsaved states)\n"
  end

  def process_input
    input = (@side == :white) ? @white.get_input : @black.get_input

    if input == "load"
      do_load
    elsif input == "save"
      do_save
    elsif input == "exit" || input == "quit"
      @done = true
    elsif input == "resign"
      @game_over = true
      puts (@side == :white) ? "Black wins!" : "White wins!"
    elsif input == "help" || input == "h"
      display_help
    elsif @board.valid_move?(input)
      success, message = @board.execute_move(input, @side)
      puts "#{message} Try again." if message
      if success
        @side = (@side == :white) ? :black : :white
      else
        @skip_board_draw = true        
      end
    else
      puts "Invalid move or command. Try again.\n"
      @skip_board_draw = true
    end
  end

  def get_yes_or_no(prompt)
    print prompt
    response = gets.chomp.downcase
    response == 'y' || response == 'ye' || response == 'yes'
  end

  def do_load
    puts "Saved games:"
    @saved_games.each { |name| puts name }
    print "Enter name of game to load: "
    name = gets.chomp
    if @saved_games.include?(name)
      file_name = @@SAVE_DIR + "/.#{name}.yml"
      @side, @white, @black, @board, @done, @game_over, @skip_board_draw = YAML.load( File.open(file_name, 'r') )
    else
      puts "Game #{name} not found."
    end
  end

  def do_save
    name = ""
    loop do
      print "Enter name of game to save: "
      name = gets.chomp
      break if name[/[a-zA-Z_0-9]+/] == name
      puts "Invalid filename. Use only letters, numbers, and underscore."
    end

    FileUtils.mkdir(@@SAVE_DIR) unless File.exist?(@@SAVE_DIR) 
    file_name = @@SAVE_DIR + "/.#{name}.yml"

    if !@saved_games.include?(name) || get_yes_or_no("Overwrite save game '#{name}'?")
      # Save the game
      File.open(file_name, 'w') do |file|
        file.puts YAML.dump([@side, @white, @black, @board, @done, @game_over, @skip_board_draw])
      end

      @saved_games << name
      @saved_games.sort!
      puts "Saved game #{name}."
    else
      puts "Game not saved."
    end
  end

  def play
    loop do
      @board = Board.new
      @board.setup
      @resign = false
      @side = :white

      answer = get_yes_or_no("Do you want White to be human? ")
      @white = answer ? Player.new(:white) : AI_Player.new(:white)

      answer = get_yes_or_no("Do you want Black to be human? ")
      @black = answer ? Player.new(:black) : AI_Player.new(:black)

      display_help

      loop do
        display_board

        if @board.in_check?(@side)
          if @board.mate?(@side)
            opponent = (@side == :white) ? "Black" : "White"
            puts "Checkmate! #{opponent} wins!"
            @game_over = true
            break
          else
            puts "Check!"
          end
        elsif @board.mate?(@side)
          puts "Stalemate!"
          @game_over = true
          break
        end

        process_input if !@game_over
        break if @done || @game_over
      end

      break if @done
      play_again = get_yes_or_no("\nPlay again? ")
      break if !play_again
    end
  end
end

if __FILE__ == $0
  # this will only run if the script was the main, not load'd or require'd

  Chess.new.play
end

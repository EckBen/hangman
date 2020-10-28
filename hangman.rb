require './one_player_game.rb'
require './playing_board.rb'
require 'json'

class Hangman < OnePlayerGame
  WORD_FILE = "5desk.txt"
  MIN_WORD_LENGTH = 5
  MAX_WORD_LENGTH = 12

  def initialize()
    @word = self.select_random_word
    @wrong_guesses = []
    @correct_guesses = []
    super(@word.length,1)
  end

  def explain_rules
    if @@game_number == 1
      puts
      puts
      puts "For this game you will face the computer"
      puts
      puts "You will be able to save at any time by typing 'save' and pressing enter"
      puts
      puts "Play by guessing a single letter at a time then pressing enter."
      puts "If you input more than a single letter, the first letter will be used as your guess."
      puts "You may only guess letters that have not yet been guessed."
      puts "If you guess wrong 6 times, you lose!"
      puts
      print "Press enter to begin a game"
      gets
      puts
      puts "Good luck!"
      puts
      puts
    end
  end

  def select_random_word
    file = File.open(WORD_FILE,"r")

    valid_words = []

    while !file.eof?
      word = file.readline.chomp
      if word.length >= MIN_WORD_LENGTH && word.length <= MAX_WORD_LENGTH
        valid_words.push(word)
      end
    end

    file.close

    valid_words[rand(valid_words.length)].split('')
  end

  def show_hangman
    case @wrong_guesses.length
    when 0
      puts "  ____   "
      puts " |    |  " 
      puts " |       " 
      puts " |       " 
      puts " |       "
      puts "_|___    " 
    when 1
      puts "  ____   "
      puts " |    |  " 
      puts " |    O  " 
      puts " |       " 
      puts " |       "
      puts "_|___    " 
    when 2
      puts "  ____   "
      puts " |    |  " 
      puts " |   _O  " 
      puts " |       " 
      puts " |       "
      puts "_|___    " 
    when 3
      puts "  ____   "
      puts " |    |  " 
      puts " |   _O_ " 
      puts " |       " 
      puts " |       "
      puts "_|___    " 
    when 4
      puts "  ____   "
      puts " |    |  " 
      puts " |   _O_ " 
      puts " |    |  " 
      puts " |       "
      puts "_|___    " 
    when 5
      puts "  ____   "
      puts " |    |  " 
      puts " |   _O_ " 
      puts " |    |  " 
      puts " |   /   "
      puts "_|___    " 
    when 6
      puts "  ____   "
      puts " |    |  " 
      puts " |   _O_ " 
      puts " |    |  " 
      puts " |   / \\ "
      puts "_|___    " 
    end
  end

  def show_wrong_guesses
    print "Bad Guesses: "
    @wrong_guesses.each { |guess| print guess + ' ' }
    puts
  end

  def get_guess
    print "Please make a guess: "
    
    while 1 do
      input = gets.chomp.downcase
      (return input) if (input == 'save')
      
      guess = input.split('')[0]
      (return guess) if !(@correct_guesses.include? guess) && !(@wrong_guesses.include? guess) && (guess.match(/[a-z]/))
      
      puts "You must choose a letter that hasn't been guessed yet."
      puts
      print "Please make a new, valid guess: "
    end
  end

  def check_guess(guess)
    if @word.include? guess
      @correct_guesses.push(guess)
    else
      @wrong_guesses.push(guess)
    end
  end

  def update_space
    @word.each_with_index do |letter, i|
      (@full_board[0][i] = letter) if (@correct_guesses.include? letter)
    end
  end

  def check_for_winner
    (return "win") if @word.uniq.length == @correct_guesses.length
    (return "lose") if @wrong_guesses.length == 6
    return "no winner yet"
  end

  def show_display
    puts
    puts
    self.show_hangman
    puts
    self.show_wrong_guesses
    puts
    puts "  --Guess this word--"
    self.show_board
    puts
  end
end


puts "Welcome to Hangman!"
new_or_load = ''
play_game = true


until new_or_load == 'n' || new_or_load == 'l'
  print "Please press 'n' for new game or 'l' to load a game."
  new_or_load = gets.chomp.downcase.split('')[0]
end

while play_game == true
  game_obj = ''
  winner = "no winner yet"

  if new_or_load == 'l'
    puts "loading"
    # Load logic
    # List saved games
    DIRECTORY = Dir.pwd
    games = []
    files = Dir.glob("#{DIRECTORY}/*.save_game")
    
    files.each do |file|
      games.push(file.split('/')[-1].split('.')[0])
    end

    puts "Please choose the number of the game you would like to play."
    
    games.each_with_index {|game, i| puts "#{i + 1}: #{game}"}
    
    selection = gets.chomp.to_i
    
    until (selection <= games.length) && (selection >= 1)
      print "Please make a valid selection: "
      selection = gets.chomp.to_i
    end

    File.open("#{DIRECTORY}/#{games[selection - 1]}.save_game","r") do |f|
      game_obj = Marshal.load(f)
    end

    new_or_load = 'n'
  else
    game_obj = Hangman.new()
  end

  game_obj.explain_rules

  until winner != "no winner yet"
    game_obj.show_display
    user_input = game_obj.get_guess
    
    if user_input == 'save'
      # Save the game
      puts
      puts "Saving game..."

      time = Time.new
      file_name = "#{time.month}-#{time.day}_#{time.hour}hr#{time.min}min.save_game"
      puts file_name

      File.open(file_name,"w+") do |f|
        Marshal.dump(game_obj,f)
      end

      puts "Game saved. Thank you for playing!"
      puts
      exit
    end
    
    game_obj.check_guess(user_input)
    game_obj.update_space
    winner = game_obj.check_for_winner
    (game_obj.change_player_id) if (winner == 'lose')
  end

  game_obj.announce_winner
  play_game = game_obj.play_again
end
require './playing_board.rb'

class OnePlayerGame < Board
  @@game_number = 1
  @@player_wins = 0
  @@computer_wins = 0
  @@ties = 0
  
  def initialize(s,r)
    super(s,r)
    @winner = "no winner yet"
    @player_id = "player"
  end

  def announce_winner
    if @player_id == "player"
      puts "You win!"
    else
      puts "The computer beat you."
    end
    # self.game_tracker(@player_id)
    # puts
    # puts
    # puts "Moving on to game #{@@game_number}, the score is:"
    # puts "You:       #{@@player_wins}"
    # puts "Computer:  #{@@computer_wins}"
    # puts
    # puts
  end

  def play_again
    puts "Would you like to play again? (y/n)"
    default = gets.chomp
    
    until default == "y" || default == "n"
      puts "Please enter 'y' or 'n'."
      default = gets.chomp
    end
    
    if default == "y"
      return true
    else
      puts
      puts "Thank you for playing!"
      puts
      return false
    end
  end

  def game_tracker(winner)
    @@game_number += 1
    
    if winner == "player"
      @@player_wins += 1
    elsif winner == "computer"
      @@computer_wins += 1
    else
      @@ties += 1
    end
  end

  def game
    self.explain_rules if @@game_number == 1
    self.play_game
    self.announce_winner
    self.play_again
  end

  def play_game
    until @winner != "no winner yet"
      self.turn
      @winner = self.check_for_winner
    end
    (self.change_player_id) if (@winner == 'lose')
  end

  def change_player_id
    @player_id = (@player_id == "player") ? "computer" : "player"
  end

  def explain_rules
    puts "Welcome to this game!"
    puts "For this game you will face the computer"
    puts
    puts "Press enter when you are ready to begin"
    gets
    puts "Good luck!"
    puts
    puts
  end

  def turn
    puts "Please make a selection."
    choice = gets.chomp
    self.update_space(choice, @player_id)
  end

  def update_space(coordinates, value)
    @full_board[coordinates[0]][coordinates[1]] = value
  end

  def check_for_winner
    return "no winner yet"
  end

end
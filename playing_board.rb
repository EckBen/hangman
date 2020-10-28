class Board
  def initialize(num_spaces, num_rows)
    @num_spaces = num_spaces
    @num_rows = num_rows
    @full_board = populate_board
  end

  def show_board
    puts '--' * @num_spaces + '-'
    @full_board.each do |row|
      row.each { |space| print "|" + space }
      puts "|"
      puts '--' * @num_spaces + '-'
    end
  end

  def populate_board
    arr = []
    for i in 1..@num_rows do
      full_row = []
      for x in 1..@num_spaces do
        full_row.push(' ')
      end
      arr.push(full_row)
    end
    arr
  end
end

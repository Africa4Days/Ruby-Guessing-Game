=begin
Chris Bell
4/18/19
Final

1. ask the user if they want to play a guessing game
2. if no say goodbye and terminate
3. if yes display rules and start game
4. Open file and store into array
5. pick random phrase from array each time played
6. display to user the length of the phrase with _ for letters and spaces as spaces
7. keep track of turns
8. have players guess letters
9. new point values generated every turn cycle
10. loop through phrase selected and see if a letter matches
11. if it does redisplay _ with the blanks filled in where the letters are
12. if it doesnt let the user know
13. dont change turns until the user incorrectly guesses
14. add random points mulitplied by the times the letter appears in the word to score if user correctly guesses
15. once word is guessed, display who won based on point values

=end
# Put phrases into an array
phrases = File.readlines("phrases.txt")
arr = phrases.each {|line|}
phrases_arr = arr.collect(&:strip)
# Generate random number for use of index
rand_phrase_num = rand(phrases_arr.count)
# Assign random phrase within array
rand_phrase = phrases_arr[rand_phrase_num]

class Phrases
  # initialize variables
  def initialize(word)
    @word = word.downcase
    @word_arr = @word.chars
    @board_arr = []
    @board = ''
    @turn = 1
    @random_points = rand(100)
    @count = 0
    @player_one_points = 0
    @player_two_points = 0
  end

# create the game board based off of the word and show the board
  def create_board
    for i in 0..@word_arr.length - 1
      if (@word_arr[i] =~ /[a-zA-Z]/ or @word_arr[i] =~ /[0-9]/)
        @board_arr.push("_")
      else
        @board_arr.push(" ")
      end
    end

    @board = @board_arr.join("")
    puts "\n#{@board}"
  end

# the logic behind the game
  def play_game
    # play the game until the board is the same as the word and no letters are left to guess
    until (@board == @word)
      puts "\nThe points for each correct guess this turn is #{@random_points}\n\n"

      if (@turn == 1)
        puts "Player one's turn: Player one currently has #{@player_one_points} points.\n"
      else
        puts "Player two's turn: Player two currently has #{@player_two_points} points.\n"
      end

      puts "Please enter a letter or number player #{@turn}"
      letter = gets.chomp.to_s.downcase
      positions = @word.enum_for(:scan, /#{letter}/).map { Regexp.last_match.begin(0) }

      if (positions.length != 0)
        puts "\nCorrect! There is #{positions.length} of the letter #{letter}!\n"
        if (@turn == 1)
          @player_one_points = @player_one_points + @random_points * positions.length
        else
          @player_two_points = @player_two_points + @random_points * positions.length
        end
      else
        puts "\nIncorrect! There is not a(n) #{letter}!\n\n"
        change_turn
      end

      # turn the board into the correct letter that was guessed at the correct index
      positions.map { |e| @board[e] = letter }
      puts @board

      # change the point value if both players have played their turns
      random_point_change
    end
  end

  # changing the turn
  def change_turn
    @count = @count + 1
    if (@turn == 1)
      @turn = 2
    else
      @turn = 1
    end
  end

  # changing the random points if both players have played their turn
  def random_point_change
    if (@count % 2 == 0)
      @random_points = rand(100)
    else
      @random_points = @random_points
    end
  end

  # if the word is guessed display the winner with the most points
  def winner
    if (@board == @word)
      if (@player_one_points > @player_two_points)
        puts "Player one is the winner with #{@player_one_points} points! Player two lost with #{@player_two_points} points."
      else
        puts "Player two is the winner with #{@player_two_points} points! Player one lost with #{@player_one_points} points."
      end
    end
  end

end

# allows the user to play as many times as they like until they say no instead of rebooting program
until false
  puts "Would you like to play a guessing game? (y/n)"
  answer = gets.chomp.to_s.downcase
  if (answer == 'y')
    # show rules at the beginning of the game
    puts "The rules are: \n
    Guess a randomly generated word. Each player will be able to input one letter at a time.\n
    If the player guesses it correctly, the player is awarded with points and is able to guess again.\n
    If the player does not guess it correctly the turn is changed to the other player.\n
    The points per guess will change every time the turns cycle through.\n
    Which ever player has the most points by the time the word is guessed is the winner!\n
    The board will be displayed every turn.\n
    It will originally look like this for example: __ _____ (This would be the phrase 'hi there').\n
    If the player guesses a correct letter the board will show that.\n
    For example if the player guesses h the word will be as follows: h_ _h___\n
    Good luck!\n
    "
    # start the game
    game = Phrases.new(rand_phrase)
    game.create_board
    game.play_game
    game.winner

  elsif (answer == 'n')
    # say bye and terminate if the user does not want to play
    puts "Goodbye!"
    break
  else
    puts "incorrect input. Please type y or n."
  end
end
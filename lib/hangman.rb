# To do: Fix receive_guess method to give user another chance if they guess the same letter repeatedly
# Give user option to save game at start of every round.


module Gallows
    def display_hangman(round)
        case round
        when 0
            puts "       -------"
            puts "       |     |"
            puts "       |     @"
            puts "       |    /|\\" 
            puts "       |     |"
            puts "       |    / \\"
            puts "  _____|_________"
            puts " /     |        /|"
            puts "______________ / /"
            puts "             |  /"
            puts "______________ /"
            puts ""
        when 1
            puts ""
            puts ""
            puts ""
            puts "" 
            puts ""
            puts ""
            puts "  _______________"
            puts " /              /|"
            puts "______________ / /"
            puts "             |  /"
            puts "______________ /"
            puts ""
        when 2
            puts "       -------"
            puts "       |"
            puts "       |"
            puts "       |" 
            puts "       |"
            puts "       |"
            puts "  _____|_________"
            puts " /     |        /|"
            puts "______________ / /"
            puts "             |  /"
            puts "______________ /"
            puts ""
        when 3
            puts "       -------"
            puts "       |"
            puts "       |     @"
            puts "       |" 
            puts "       |"
            puts "       |"
            puts "  _____|_________"
            puts " /     |        /|"
            puts "______________ / /"
            puts "             |  /"
            puts "______________ /"
            puts ""
        when 4
            puts "       -------"
            puts "       |"
            puts "       |     @"
            puts "       |     |" 
            puts "       |     |"
            puts "       |"
            puts "  _____|_________"
            puts " /     |        /|"
            puts "______________ / /"
            puts "             |  /"
            puts "______________ /"
            puts ""
        when 5
            puts "       -------"
            puts "       |"
            puts "       |     @"
            puts "       |     |\\" 
            puts "       |     |"
            puts "       |"
            puts "  _____|_________"
            puts " /     |        /|"
            puts "______________ / /"
            puts "             |  /"
            puts "______________ /"
            puts ""
        when 6
            puts "       -------"
            puts "       |"
            puts "       |     @"
            puts "       |    /|\\" 
            puts "       |     |"
            puts "       |      \\"
            puts "  _____|_________"
            puts " /     |        /|"
            puts "______________ / /"
            puts "             |  /"
            puts "______________ /"
            puts ""
        when 7
            puts "       -------"
            puts "       |"
            puts "       |     @"
            puts "       |    /|\\" 
            puts "       |     |"
            puts "       |    / \\"
            puts "  _____|_________"
            puts " /     |        /|"
            puts "______________ / /"
            puts "             |  /"
            puts "______________ /"
            puts ""
        when 8
            puts "       -------"
            puts "       |     |"
            puts "       |     @"
            puts "       |    /|\\" 
            puts "       |     |"
            puts "       |    / \\"
            puts "  _____|_________"
            puts " /     |        /|"
            puts "______________ / /"
            puts "             |  /"
            puts "______________ /"
            puts ""
        end
    end
end

class Game
    include Gallows

    @@games_played = 0
    @@number_won = 0
    @@number_lost = 0

    def initialize
        $dictionary = File.read("5desk.txt")
        $dictionary = $dictionary.split(' ')
        trim_dictionary($dictionary)
        secret_word($dictionary)
        $secret_word
        $guess
        $guesses = []
        $round = 1
        $over = false
        $incorrect_guesses = []
        $ready = true
        $guessed_letters = []
        $save
    end

    def trim_dictionary(dictionary)
        new_dictionary = []
        dictionary.each_with_index do |word, index|
            if word.length >= 5 && word.length <= 12 
                new_dictionary << dictionary.slice!(index)
            end
        end
        return $dictionary = new_dictionary
    end

    def secret_word(dictionary)
        $secret_word = dictionary.sample
        # puts $secret_word
        return $secret_word.downcase!
    end

    def display_title()
        puts ""
        puts ""
        puts ""
        puts "{}    {}    {}{}     {}    {}    {}}}}}    {}      {}    {}{}     {}    {}"
        puts "{}    {}   {}  {}    {}}}  {}   {}    {}   {}}}  {{{}   {}  {}    {}}}  {}"
        puts "{}{{}}{}  {}{{}}{}   {} {} {}   {}         {} {{}} {}  {}{{}}{}   {} {} {}"
        puts "{}    {}  {}    {}   {}  {{{}   {}  {{{{   {}  {}  {}  {}    {}   {}  {{{}"
        puts "{}    {}  {}    {}   {}    {}    {}}}}}    {}      {}  {}    {}   {}    {}"
        puts ""
        puts ""
        puts ""
    end


    def display_rules
        puts "The computer will choose a secret word."
        puts "You have to guess that word before the man is hung!"
        puts "On the seventh incorrect guess, the game is lost."
        puts ""
    end

    def display_word
        $secret_word.length.times do |i|
            if $guesses[i] == nil || $guesses[i] == false
                print " _ "
            elsif $guesses[i] == true
                print " #{$secret_word[i].upcase} "
            end
        end
        puts ""
        puts ""
        puts ""
    end

    def receive_guess
        print "What is your guess? "
        $guess = gets.chomp.downcase
        while $guess =~ /[^a-z]/
            print "Please enter a letter. "
            $guess = gets.chomp.downcase
        end
        while $guessed_letters.include?($guess)
            puts "You already guessed that letter."
            print "Please try again. "
            $guess = gets.chomp.downcase
        end
        $guessed_letters << $guess
        puts ""
    end

    def compare_guess
        incorrect = true
        $secret_word.each_char.with_index do |c, i|
            if $guesses[i] == true
                # do nothing
            elsif $guess == c
                $guesses[i] = true
                incorrect = false
            else
                $guesses[i] = false
            end
        end
        if incorrect == true
            $incorrect_guesses << $guess
            $round += 1
        end
    end

    def play_round
        puts "Round #{$round}"
        puts ""
        display_hangman($round)
        display_word
        receive_guess
        compare_guess
        puts ""
        puts "Incorrect guesses: #{$incorrect_guesses}"
        puts ""
    end

    def won?
        if $incorrect_guesses.length == 7
            display_hangman(8)
            puts ""
            puts "The computer wins this time!"
            puts ""
            puts "The secret word was #{$secret_word}."
            puts ""
            @@games_played += 1
            @@number_lost += 1
            return $over = true
        end
        if $guesses.all?
            puts ""
            puts "Congratulations! You have won the game!"
            puts ""
            @@games_played += 1
            @@number_won += 1
            return $over = true
        end
    end

    def ready_to_play?
        if @@games_played == 0
            print "Are you ready to play? (y/n) "
            $ready = gets.chomp
            puts ""
            while $ready
                if $ready == "n"
                    puts "Goodbye!"
                    puts ""
                    exit
                elsif $ready == "y"
                    puts "Here we go!"
                    return
                else 
                    puts "Let's try that again."
                    print "Ready to play? (y/n) "
                    $ready = gets.chomp
                    puts ""
                end
            end
        else
            if @@games_played == 1
                puts "You have played #{@@games_played} game."
            else
                puts "You have played #{@@games_played} games."
            end
            puts "You: #{@@number_won} ... Computer: #{@@number_lost}"
            puts ""
            save_game
            print "Would you like to play again? (y/n) "
            $ready = gets.chomp
            puts ""
            while $ready 
                if $ready == "n"
                    puts "Goodbye!"
                    puts ""
                    return $ready = false
                elsif $ready == "y"
                    initialize
                    display_hangman(0)
                    $round = 1
                    return
                else 
                    puts "Check your spelling."
                    print "Play again? (y/n) "
                    $ready = gets.chomp
                    puts ""
                end
            end
        end
    end

    def play_game
        load_game?
        while $ready
            $over = false
            while $over == false
                play_round
                won?
            end
            ready_to_play?
        end
    end

    def save_game
        print "Would you like to save your game? (y/n) "
        $save = gets.chomp
        puts ""
        while $save
            if $save == "n"
                puts "Not saving..."
                puts ""
                $save = false
            elsif $save == "y"
                puts "Saving..."
                puts ""
                Dir.mkdir("saved_game") unless Dir.exists? "saved_game"
                filename = "saved_game/hangman_save.rb"
                data = "#{@@number_won}, #{@@number_lost}"
                File.write(filename, data, mode: "w")
                $save = false
            else 
                puts "Let's try that again."
                print "Save your game? (y/n) "
                $save = gets.chomp
                puts ""
            end
        end
        # File.close(filename)
    end


    def load_game?
        print "Would you like to open the saved game? (y/n) "
        open_game = gets.chomp
        puts ""
        if open_game == "y"
            data = File.readlines("saved_game/hangman_save.rb", "r")
            data = data.join
            data = data.split(", ")
            @@number_won = data[0].to_i
            @@number_lost = data[1].to_i
            puts "Number won: #{@@number_won}"
            puts "Number lost: #{@@number_lost}"
            puts ""
        end
    end
end

hangman = Game.new
hangman.display_title
hangman.display_rules
hangman.display_hangman(0)
hangman.ready_to_play?
hangman.play_game
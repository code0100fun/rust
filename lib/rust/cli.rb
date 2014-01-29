require "readline"
require 'colorize'

module Rust
  class Cli
    def initialize
      restore_history
      setup_readline
    end

    def restore_history
      hist = history_config.read
      hist.each { |h| Readline::HISTORY << h } unless hist.nil? || hist.length == 0
    end

    def save_history
      hist = Readline::HISTORY.to_a
      history_config.write hist
    end

    def setup_readline
      command_proc = proc do |s|
        commands.grep(/^#{Regexp.escape(s)}/)
      end
      Readline.completion_proc = command_proc
      Readline.completion_append_character = ""
      Readline.basic_word_break_characters += "."
    end

    def commands
      ['teleport', 'topos ']
    end

    def command_methods
      {
        'teleport' => ['topos']
      }
    end

    def run
      login
      begin
        while !quit?
          command_text = ask("> ")
          if command_text.chomp == "exit"
            quit
          else
            command = Rust::Command.new command_text
            handle_response command.run
          end
        end
      rescue Interrupt
        puts "\n"
        quit
      end
    end

    def quit
      @_quit = true
      puts "exiting..."
      save_history
    end

    def quit?
      @_quit ||= false
    end

    def config
      @_config ||= Rust::Config.new
    end

    def history_config
      @_history_config = Rust::ConfigFile.new 'history.yml'
    end

    def ask_no_echo prompt
      @state = `stty -g`
      system "stty raw -echo -icanon isig"
      line = ask prompt
      system "stty #{@state}"
      print "\n"
      line
    end

    def ask prompt, options={}
      Readline.readline(prompt, true)
    end

    def login
      while config.need_login?
        puts "You must login to Multiplay".colorize(:light_cyan)
        email = ask("Multiplay Email:  ")
        password = ask_no_echo("Multiplay Password:  ")
        auth = Rust::Authenticate.new
        puts "Connecting to Multiplay...".colorize(:light_cyan)
        auth.login email.to_s, password.to_s
        if config.need_login?
          unsuccessful_login
        else
          successful_login(email.to_s)
        end
      end
    end

    def unsuccessful_login
      puts "Error logging in!".red
    end

    def successful_login email
      puts "Logged in as #{email}".green
    end

    def handle_response res
      if res["success"]
        puts "success".green
      elsif res["message"]
        puts res["message"].red
        if res["status"] == "422"
          config.clear_login
          login
        end
      end
    end

  end
end

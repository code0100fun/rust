require 'readline'
require 'colorize'

module Rust
  class Cli

    include Rust::Configurable

    def initialize
      restore_history
      setup_readline
    end

    def execute!
      run
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
        (commands+custom_commands).sort.grep(/^#{Regexp.escape(s)}/)
      end
      Readline.completion_proc = command_proc
      Readline.completion_append_character = ""
      Readline.basic_word_break_characters += "."
    end

    def commands
      ['teleport', 'topos', 'toplayer']
    end

    def command_methods
      {
        'teleport.' => ['topos', 'toplayer']
      }
    end

    def custom_commands
      ['servers','players']
    end

    def run
      login
      begin
        while !quit?
          command_text = ask("> ")
          if command_text.nil?
            quit true
          elsif command_text.chomp == "exit"
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

    def quit silent=false
      @_quit = true
      puts "exiting..." unless silent
      save_history
    end

    def quit?
      @_quit ||= false
    end

    def history_config
      @_history_config = Rust::ConfigFile.new 'history.yml'
    end


    def windows?
      ENV['SYSTEMROOT'] =~ /C:\\WINDOWS/i
    end

    def ask_no_echo prompt
      unless windows?
        @state = `stty -g`
        system "stty raw -echo -icanon isig"
      end
      line = ask prompt,false
      unless windows?
        system "stty #{@state}"
      end
      print "\n"
      line
    end

    def ask prompt, add_hist=true
      Readline.readline(prompt, add_hist)
    end

    def login
      while config.need_login?
        puts "You must login to Multiplay".colorize(:light_cyan)
        email = ask("Multiplay Email: ").chomp
        password = ask_no_echo("Multiplay Password:").chomp
        puts "Connecting to Multiplay...".colorize(:light_cyan)
        Rust::Session.create email, password
        if config.cookie.nil?
          puts "Error logging in!".red
        else
          puts "Connected".green
          puts "Fetching user data...".colorize(:light_cyan)
          Rust::User.fetch
          if config.token.nil?
            puts config.filename
            puts "Could not get a token for #{email}".red
          else
            puts "Successfully logged in as #{email}".green
            puts "Fetching server list...".colorize(:light_cyan)
            Rust::Servers.fetch
            if config.servers.nil?
              puts "Failed to get a list of servers for #{email}".red
            else
              puts "Found #{config.servers.length} servers".green
            end
          end

        end
      end
    end

    def handle_response res
      if res["success"]
        puts "success".green
      elsif res["message"]
        puts res["message"].red
        if res["status"] == "422"
          config.clear_login
          puts res.inspect
          login
        end
      else
        config.clear_login
        puts res.inspect
        login
      end
    end

  end
end

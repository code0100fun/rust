require 'yaml'
require 'fileutils'

module Rust

  class ConfigFile

    def initialize filename=nil
      self.filename = filename
    end

    def file_path filename
      return nil if filename.nil?
      File.expand_path filename, default_directory
    end

    def filename= filename
      @_filename = file_path filename
      @_filename ||= file_path default_filename
    end

    def filename
      @_filename
    end

    def default_directory
      '~/.rust/'
    end

    def default_filename
      'config.yml'
    end

    def write contents
      init_file
      File.open(filename, 'w') do |f|
        f.write contents.to_yaml
      end
    end

    def exists?
      File.exists? filename
    end

    def create
      FileUtils.mkdir_p(File.dirname(filename))
      FileUtils.touch(filename)
      write({})
    end

    def delete
      FileUtils.rm_rf(filename)
    end

    def init_file
      create unless exists?
    end

    def read
      init_file
      YAML::load( File.open(filename) )
    end
  end
end

require 'yaml'
require 'fileutils'

module Rust

  class ConfigFile
    class << self

      def file_name
        'config.yml'
      end

      def write contents
        File.open(file_name, 'w') do |f|
          f.write contents.to_yaml
        end
      end

      def exists?
        File.exists? file_name
      end

      def create
        FileUtils.mkdir_p(File.dirname(file_name))
        FileUtils.touch(file_name)
        write({})
      end

      def delete
        FileUtils.rm_rf(file_name)
      end

      def init_file
        create unless exists?
      end

      def read
        init_file
        YAML::load( File.open(file_name) )
      end
    end
  end
end

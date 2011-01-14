require 'yaml'

module Perb
  class Session
    include Enumerable
    def initialize(test_path)
      raise Errno::ENOENT unless File.exist?(test_path)
      
      @test_files=[]
      tests = []

      if(File.directory?(test_path))
        @test_files = Dir.glob("#{test_path}/*.yml")
      else
        @test_files << test_path
      end
    end

    def each
      @test_files.each do |file|
        YAML::load(File.open(file)).each do |test|
          yield test
        end        
      end
    end
  end
end

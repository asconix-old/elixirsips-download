desc "Loads Pry console with downloader"
task :console do
  require 'pry'
  require 'pry-byebug'
  require 'awesome_print'
  require 'pry-doc'
  load './download.rb'
  ARGV.clear
  Pry.start
end

def reload!
  load './download.rb'
end

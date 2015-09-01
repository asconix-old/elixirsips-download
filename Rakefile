def reload!
  load './download.rb'
end

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

desc "Batch download all videos"
task :batch_download do
  load './download.rb'

  d = ElixirSips::Downloader.new
  d.download_all
end

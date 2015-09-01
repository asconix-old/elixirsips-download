require 'mechanize'
require 'rss'
require 'pry'

module ElixirSips
  # Downloader for Elixir Sips Episodes.
  class Downloader
    attr_reader :catalog,
                :username,
                :password,
                :login_form,
                :client,
                :feed,
                :episodes

    def initialize
      @client     = Mechanize.new
      @login_form = @client.get('https://elixirsips.dpdcart.com/subscriber/content').forms.first
      @username   = ''
      @password   = ''
    end

    # Receives number from the episode list given in #episodes
    def download(number)
      prepare_auth unless @auth_prepared

      _download(episode number)
      return true
    end

    # Can you guess what it does?
    def download_all
      prepare_auth unless @auth_prepared

      episodes.each do |episode_number, _episode_info|
        download episode
      end
    end

    # Gives list with all episodes and their names.
    def episodes
      prepare_auth unless @auth_prepared

      @episodes ||= parse_episodes
    end

    def episode number
      prepare_auth unless @auth_prepared

      return "There's only #{episodes.count} episodes" unless number.between?(0, episodes.count)
      self.episodes[number]
    end

    # We want it to be public in case we wanna rebuild the episode list.
    def build_episode_list
      parse_episodes
    end

    private

    def prepare_auth
      login
      @feed ||= fetch_rss_feed
      build_episode_list

      @auth_prepared = true
    end

    # Logs in Elixir Sips.
    def login
      login_form.username = username
      login_form.password = password
      login_form.submit
    end

    # Gets the RSS Feed.
    def fetch_rss_feed
      feed_url = 'https://elixirsips.dpdcart.com/feed'
      client.add_auth feed_url, username, password
      RSS::Parser.parse client.get(feed_url).body
    end

    # Parses all episodes and their files
    # Hash:
    #
    def parse_episodes
      episodes = {}

      feed.items.reverse.each do |episode|
        number = episode.title[0..2].to_i
        title  = episode.title
        url    = episode.link
        files  = parse_files episode

        episodes[number] =
          {
            title: title,
            url: url,
            files: files
          }
      end

      episodes
    end

    # Parses all files from an episode description.
    # Hash:
    # { file_name: <name of the file>, file_link: <link to download the file> }
    def parse_files episode
      files = {}

      begin
        document = REXML::Document.new episode.description
      rescue => e
        # puts "EPISODE ERROR:"
        # puts "TITLE: #{episode.title}"
        # puts "MESSAGE: #{e.message}"
        return
      end

      document.elements.each("/div[@class='blog-entry']/ul/li/a") do |element|
        files = []

        file_name = element.text
        file_link = element.attribute('href').to_s
        files << { file_name: file_name, file_link: file_link }
      end

      files
    end

    # Creates the container folder for all episodes.
    # String:
    # i.e: /User/rojo/episodes
    def episodes_dir
      current_dir  = File.expand_path File.dirname(__FILE__)
      episodes_dir = "#{current_dir}/episodes"
      Dir.mkdir(episodes_dir) unless File.exist? episodes_dir
      episodes_dir
    end

    # Creates a given episode folder, inside the container folder.
    # String:
    # i.e: /Users/rojo/episodes/
    def _download episode
      # Create folder if doesn't exist
      title_dir = "#{episodes_dir}/#{episode[:title]}"
      Dir.mkdir(title_dir) unless File.exists? title_dir

      # Download the files.
      episode[:files].each do |file|
        client.download file[:file_link], title_dir
      end
    end
  end
end

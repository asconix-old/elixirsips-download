require 'mechanize'
require 'rss'
require 'pry'

# @author Feña Agar
module ElixirSips
  # @author Feña Agar
  class Downloader

    # Mechanize client instance.
    attr_reader :client

    attr_reader :episodes

    # Your Elixir Sips username.
    attr_accessor :username

    # Your Elixir Sips password.
    attr_accessor :password

    # URL to validate login credentials.
    LOGIN_URL = 'https://elixirsips.dpdcart.com/subscriber/content'

    # URL of the RSS Feed, needs to be authenticated first.
    FEED_URL  = 'https://elixirsips.dpdcart.com/feed'

    # Creates an instance of the downloader.
    # @param none
    # @return [ElixirSip::Downloader]
    def initialize
      @client        = Mechanize.new
      @username      = ''
      @password      = ''
      @auth_prepared = false
    end

    # Downloads one episode.
    # @param number [Integer] the episode number you want to download.
    # @return [nil]
    def download(number)
      prepare_auth unless @auth_prepared
      _download(episode number)
    end

    # Downloads all episodes.
    # @param none
    # @return [nil]
    def download_all
      prepare_auth unless @auth_prepared
      episodes.each do |number, _info|
        _download(episode number)
      end
    end

    # Lists all episodes and their details.
    # @param relogin [Boolean] refreshes auth credentials and fetches episodes again.
    # @return [Hash]
    def episodes(relogin: false)
      prepare_auth if @auth_prepared == false || relogin == true
      @episodes = parse_episodes
    end

    # Lists a given episode details.
    # @param number [Integer] the episode number you want to check.
    # @return [Hash] a hash with the episode details.
    def episode(number)
      prepare_auth unless @auth_prepared
      return "There's only #{episodes.count} episodes" unless number.between?(0, episodes.count)
      episodes[number]
    end

    private

    # Login, fetch RSS feed and build episode list for later use.
    # Also sets the `@feed` instance var.
    # @param none
    # @return [Boolean] sets the `@auth_prepared` instance variable to prevent multiple calls.
    def prepare_auth
      login
      @feed = fetch_rss_feed
      @auth_prepared = true
    end

    # Logs into Elixir Sips.
    # @param none
    # @return none
    def login
      @login_form ||= client.get(LOGIN_URL).forms.first
      @login_form.username = username
      @login_form.password = password
      @login_form.submit
    end

    # Fetches and parse the RSS Feed.
    # @param none
    # @return [RSS::Rss] parsed feed.
    def fetch_rss_feed
      client.add_auth FEED_URL, username, password
      RSS::Parser.parse client.get(FEED_URL).body
    end

    # Parses all episodes and their details (Basic info and attached files).
    # @param none
    # @return [Hash] contains all episodes and their info using their episode number as the key.
    def parse_episodes
      episodes = {}

      @feed.items.reverse.each do |episode|
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
    # @param episode [Hash] a hash containing a single episode and its details.
    # @return [Hash] a hash containing more hashes with the files names and links.
    #
    #   <episode_number>: {
    #     file_name: "<file_name>",
    #     file_link: "<file_link>"
    #   }
    def parse_files(episode)
      begin
        document = REXML::Document.new episode.description
      rescue => _e
        # puts "EPISODE ERROR:"
        # puts "TITLE: #{episode.title}"
        # puts "MESSAGE: #{_e.message}"
        return
      end

      files = []
      document.elements.each("/div[@class='blog-entry']/ul/li/a") do |element|
        file_name = element.text
        file_link = element.attribute('href').to_s
        files << { file_name: file_name, file_link: file_link }
      end

      files
    end

    # Creates the container folder for all episodes.
    # @param none
    # @return [String] the route to the `episodes` folder.
    def episodes_dir
      current_dir  = File.expand_path File.dirname(__FILE__)
      episodes_dir = "#{current_dir}/episodes"
      Dir.mkdir(episodes_dir) unless File.exist? episodes_dir
      episodes_dir
    end

    # Creates a folder for the episode, its files and then downloads them.
    # @param episode [Hash] a hash with the episode details.
    # @return [nil]
    def _download(episode)
      # Create folder if doesn't exist
      title_dir = "#{episodes_dir}/#{episode[:title]}"
      Dir.mkdir(title_dir) unless File.exist? title_dir

      # Download the files.
      puts "Downloading to #{title_dir}"
      episode[:files].each do |file|
        file_dir = "#{title_dir}/#{file[:file_name]}"

        if not File.exist? file_dir
          puts "-- #{file[:file_name]}"
          client.download file[:file_link], file_dir
        else
          puts "-- Skipping #{file[:file_name]}, it already exists."
        end
      end
    end
  end
end

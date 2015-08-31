require 'mechanize'
require 'pry'

module ElixirSips
  class Downloader
    attr_reader :username, :password, :login_form

    def initialize
      @client = Mechanize.new
      @login_form = @client.get("https://elixirsips.dpdcart.com/subscriber/content").forms.first
    end

    def login
      login_form.username = ""
      login_form.password = ""
      login_form.submit
    end
  end
end

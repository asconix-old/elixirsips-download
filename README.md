## elixirsips-download

_Download episodes from [Elixir Sips](http://elixirsips.com)_

## Project Setup

First install gems:

```shell
bundle install
```

Remember to place your user and password:

```ruby
def initialize
  (...)
  @username   = '<your_username>'
  @password   = '<your_password>'
end
```

### **Then, do magic:**

For just one episode:

```ruby
=> d = ElixirSips::Downloader.new
=> d.download 1 # Download episode 1.
```

For all of them:

```ruby
=> d = ElixirSips::Downloader.new
=> d.download_all # Download all episodes.
```

You can list episodes:

```ruby
=> d = ElixirSips::Downloader.new
=> d.episodes # List all episodes.
```

Or list just one episode's info:

```ruby
=> d = ElixirSips::Downloader.new
=> d.episode 1 # List just episode 1 information.
```



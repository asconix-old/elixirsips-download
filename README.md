elixirsips-download
-------

_Download episodes from [Elixir Sips](http://elixirsips.com)_

## Project Setup

1. Install gems:

    ```shell
    $ bundle install
    ```

2. Remember to place your user and password:

    ```ruby
    def initialize
      (...)
      @username   = '<your_username>'
      @password   = '<your_password>'
    end
    ```

3. Fire up the console:

    ```shell
    $ rake console
    ```

### **Do magic**

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

Then download just one episode:

```ruby
=> d = ElixirSips::Downloader.new
=> d.download 1 # Download episode 1.
```

Or all of them:

```ruby
=> d = ElixirSips::Downloader.new
=> d.download_all # Download all episodes.
```

You can even run it from your shell and do a batch_download:

```shell
$ nohup rake batch_download &
$ jobs
[1]  + running    nohup rake batch_download
```



Warning
-------

Except for a few episodes, Elixir Sips is a paid screencast series. Therefore, please
don't redistribute the downloaded material. This downloader is
only an utility tool and doesn't substitute the subscription.

You should do no evil!


Acknowledgements
-------

If you're wondering why create yet-another-downloader, it's because [elixir-sips-downloader](https://github.com/benjamintanweihao/elixir-sips-downloader) is broken.

Also, the Go and Python script out there won't organize the files in separated directories or let you download just one episode at a time.

And the [ruby-tapas-downloader](https://github.com/stupied4ever/ruby-tapas-downloader) (which can be "easily" ported to work with elixir sips) is kinda overdesigned, I did get some ideas from there to make this one though.

License ![WTFPL](http://www.wtfpl.net/wp-content/uploads/2012/12/wtfpl-badge-2.png)
-------
               DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                       Version 2, December 2004

    Copyright (C) 2015 Feña Agar <fernando.agar@gmail.com>

    Everyone is permitted to copy and distribute verbatim or modified
    copies of this license document, and changing it is allowed as long
    as the name is changed.

               DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
      TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

     0. You just DO WHAT THE FUCK YOU WANT TO.

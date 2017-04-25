# Telegram::Rabbit

## Work in progress

RabbitMQ wrapper for [`telegram-bot-ruby`](https://github.com/atipugin/telegram-bot-ruby). Runs bot client and communicates with other apps via rabbitmq.

Use [`telegram-rails`](https://github.com/govorov/telegram-rails) for communication with rails applications.

## Usage

Create file with something like this:

```
require 'telegram/rabbit'

options = {
  queue_namespace: :my_super_app,
  bot: {
    #give a name to your bot
    name: :main,
    #specify a token
    token: "your_token_goes_here"
  }
  #everithing from :bunny will be passed to Bunny constructor
  bunny: {
    ...
  }
}

Telegram::Rabbit::ClientAdapter.new(options).start

```

And run it.

## TODO

* Error handling
* Graceful shutdown
* Documentation


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


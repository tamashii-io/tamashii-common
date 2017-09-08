Tamashii Common
===

Tamashii Common is a collection of some commonly used features in Tamashii, including recorded, setting, packet encapsulation, etc.

## Installation

Add the following code to your `Gemfile`:

```ruby
gem 'tamashii-common'
```

And then execute:
```ruby
$ bundle install
```

Or install it yourself with:
```ruby
$ gem install tamashii-common
```

## Usage

### Tamashii::Resolver

Used to handle with different types of packets in Tamashii.

```ruby
Tamashii::Resolver.handle Tamashii::AUTH_TOKEN, Tamashii::Manager::Authorization
```

#### Default processing

In the absence of a specified processing mode, we can specify the way the default processing.

```ruby
Tamashii::Resolver.default_handler Tamashii::Manager::Handler::Broadcaster
```

#### Hook

This is a mechanism similar to Rack Middleware, which can intercept or process packets before the Handler executes.

```ruby
Tamashii::Resolver.hook TamashiiRailsHook
```

When there are lots of items need to be setting, we can write the following way instead.

```ruby
Tamashii::Resolver.config do
  handler Tamashii::Manager::Authorization
  # ...

  hook MyRailsHook
  # ...
end
```

### Tamashii::Packet

IoT devices need some information about the data when transferring, so define a simple format to encapsulate the data in Tamashii.

|Field  |Size     |Description
|---    |---      |-
|type   | 1byte   |control code(Octal)
|tag    | 2bytes  |tag, default 0 is broadcast（will be removed）
|size   | 2bytes  |data size
|body   | ~       |data content

We can use `Tamashii::Packet`  to encapsulate different types of information, e.g., String, JSON,and Binary.

```ruby
packet = Tamashii::Packet.new(Tamashii::Type::AUTH_TOKEN, 0, '1234')
```

When we transfer data, we will translate the data into a Binary format before the transmission. If you want to convert, then we can use `dump` and `load` these two methods.

```ruby
buffer = packet.dump
recv_packet = Tamashii::Packet.load(buffer)
```

To get the original content of the data, you can use `type` and` body` to determine what information you want to access.

```ruby
if packet.type == Tamashii::Type::AUTH_TOKEN
  puts packet.body # AUTH_TOKEN is a string
end
```

### Tamashii::Type

There are a wide variety of types data exchange in Tamashii. In order to access these packet easily, we define a series of settings to assist in accessing these types.

```ruby
# System Action
Tamashii::Type::POWEROFF
Tamashii::Type::REBOOT
# ...
```

|Type id|Name|Description
|------|---------|-
|000   |POWEROFF|Shut down
|001   |REBOOT|Restart
|002   |RESTART|Restart service
|003   |UPDATE|Update the software
|010   |AUTH_TOKEN|Token certification
|017   |AUTH_RESPONSE|Certification results
|030   |RFID_NUMBER|Authentication card number
|031   |RFID_DATA|Card information
|036   |RFID_RESPONSE_JSON|Card reader results
|037   |RFID_RESPONSE_STRING|Card reader results
|040   |BUZZER_SOUND|Make buzzer sound
|050   |LCD_MESSAGE|Display LCD text
|051   |LCD_SET_IDLE_TEXT|Set the display text when standby

## Development

To get the source code

    $ git clone git@github.com:tamashii-io/tamashii-common.git

Initialize the development environment

    $ ./bin/setup

Run the spec

    $ rspec

Installation the version of development on localhost

    $ bundle exec rake install
## Contribution

Please report to us on [Github](https://github.com/tamashii-io/tamashii-common) if there is any bug or suggested modified.

The project was developed by [5xruby Inc.](https://5xruby.tw/)


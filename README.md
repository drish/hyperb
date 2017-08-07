# Hyperb

Hyperb is a [hyper.sh](https://hyper.sh) API ruby gem.

This gem is under active development.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hyperb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hyperb


## Configuration

```ruby
client = Hyperb::Client.new(access_key: 'ak', secret_key: 'sk')
```

## API Covered

#### Images

Inspect Image :white_check_mark:

Create Image (with auth object included)  :white_check_mark:

List Images  :white_check_mark:

Remove Image :white_check_mark:

## Contributing

Bug reports and pull requests are welcome at https://github.com/drish/hyperb.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

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

## APIs (v1.23) Covered

### Images

* inspect image
* create image
* list images
* remove images

### Volumes

* list volumes
* inspect volume
* remove volume

### Containers

* create container
* start container
* kill container
* get container logs
* get container stats
* remove containers

## Contributing

Bug reports and pull requests are welcome at https://github.com/drish/hyperb.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

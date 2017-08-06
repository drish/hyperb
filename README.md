# Hyperb

Hyperb is a [hyper.sh](https://hyper.sh) API client ruby gem.

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

## API

#### Version

```ruby
client.version
=> {
	"Version"=>"Hyper.sh Public Service",
	"ApiVersion"=>"1.23",
	"GitCommit"=>"",
	"GoVersion"=>"go1.8.1",
	"Os"=>"linux",
	"Arch"=>"amd64",
	"KernelVersion"=>"4.0.0"
}
```

### Images

#### images

returns an Array of Hyperb::Image

```ruby
images = client.images
images.each do |image|
  image.is_a?(Hyperb::Image)
  puts image
end
```

#### create_image

return a HTTP::Response::Body, which can be streamed.

```ruby
response = client.create_image from_image: 'busybox'
puts response
```

```ruby
response = client.create_image(from_image: 'busybox')
while !response.readpartial.nil?
  puts response.readpartial
end
```

Authenticating in a third party docker registry, you must provide a AuthObject, example with gcr [service account](https://cloud.google.com/container-registry/docs/advanced-authentication).

```ruby
x_registry_auth = {
  username: '_json_key',
	password: File.new('./path/to/service-account.json')
	email: 'email@email.com',
	serveraddress: 'https://gcr.io'
}
response = client.create_image(from_image: 'gcr.io/private/repo/image', x_registry_auth)
puts response
```

#### remove_image

returns an Array of hashes containing information about the deleted image

```ruby
response = client.remove_image(name: 'busybox')
=> [{:untagged=>"busybox:latest"}, {:deleted=>"sha256:efe10ee6727fe52d2db2eb5045518fe98d8e31fdad1cbdd5e1f737018c349ebb"}]
```

Force delete

```ruby
response = client.remove_image(name: 'busybox', force: true)
=> [{:untagged=>"busybox:latest"}, {:deleted=>"sha256:efe10ee6727fe52d2db2eb5045518fe98d8e31fdad1cbdd5e1f737018c349ebb"}]
```

#### inspect_image

returns a Hash containing information about the inspected image

```ruby
info = client.inspect_image(id: 'busybox')
puts info
```

### Containers

TODO:

### Volumes

#### remove_volume

```ruby
client.remove_volume(id: 'volume-name')
```

### Fips

TODO:

## Contributing

Bug reports and pull requests are welcome at https://github.com/drish/hyperb.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

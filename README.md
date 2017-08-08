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

Hyper.sh requires you to create credentials on their [dashboard](https://console.hyper.sh/account/credential), after that you can configure your client as following:

```ruby
client = Hyperb::Client.new(access_key: 'ak', secret_key: 'sk')
```

## Usage Examples

After configuring a `client`, you can do the following things.

**get api version**

```ruby
client.version
```
**fetch all images**

```ruby
client.images
```
**remove an image**

```ruby
client.remove_image id: 'id-or-name'
```
**create an image (pull)**

```ruby
client.create_image from_image: 'busybox'
```
**pull an image from gcr (using service account)**

```ruby
client.create_image from_image: 'gcr.io/project/owner/gcr', x_registry_auth: { username: '_json_key', password: File.new('./path/service-account.json'), email: 'e@e.com', serveraddress: 'https://gcr.io' }
```

**create container (defaults to s1 size)**

```ruby
client.create_container name: 'nginx-container', image: 'nginx'
```

**create container with specific size**

```ruby
client.create_container name: 'nginx-container', image: 'nginx', labels: { sh_hyper_instancetype: 'm1' }
```

**start container**

```ruby
client.start_container name: 'nginx-container'
```

**container logs**

```ruby
logs = client.container_logs id: 'nginx', stdout: true, stderr: true, follow: true

while body = logs.readpartial(1024)
  puts body
end
```

**allocate an floating ip**

```ruby
ips = client.fip_allocate count: 2
puts ips
#['8.8.8.8', '5.5.5.5']
```

For more usage examples, please see the full [documentation]().

## APIs (v1.23) Covered

[API](https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/index.html)

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

* create container (not all arguments supported yet)
* start container
* stop container
* kill container
* get container logs
* get container stats
* remove containers
* rename container

### Network

* floating ip allocate
* floating ip release
* floating ip list
* floating ip attach

### Compose

wip

### Snapshot

wip

### Service

wip


### Security Groups

wip

### Event

wip

### Misc.

* Version

### Func (beta)

wip


### Cron (beta)

wip

## Contributing

Bug reports and pull requests are welcome at https://github.com/drish/hyperb.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

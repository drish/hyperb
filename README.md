<p align="center">
  <h1 align="center">Hyperb</h1>
  <p align="center">Hyperb is a <a href="https://hyper.sh">Hyper.sh</a> API ruby gem.</p>
  <p align="center">
    <a href="https://circleci.com/gh/drish/hyperb"><img src="https://circleci.com/gh/drish/hyperb.svg?style=svg"></a>
    <a href="https://github.com/drish/hyperb/blob/master/LICENSE.txt"><img src="https://img.shields.io/badge/license-MIT-blue.svg"></a>
    <a href="https://rubygems.org/gems/hyperb"><img src="https://img.shields.io/gem/dt/hyperb.svg?style=flat-square"></a>
    <a href="https://coveralls.io/github/drish/hyperb?branch=master"><img src="https://coveralls.io/repos/github/drish/hyperb/badge.svg?branch=master"></a>
		<a href="https://codeclimate.com/github/drish/hyperb"><img src="https://codeclimate.com/github/drish/hyperb/badges/gpa.svg" /></a>
		<a href="https://badge.fury.io/rb/hyperb"><img src="https://badge.fury.io/rb/hyperb.svg"</></a>
  </p>
</p>

---

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
client = Hyperb::Client.new(access_key: 'ak', secret_key: 'sk', region: 'us-west-1')
```

or 

```ruby
client = Hyperb::Client.new do |client|
  client.secret_key = 'secret_key'
  client.access_key = 'access_key'
  client.region = 'eu-central-1'
end
```

If `region` is not set, `us-west-1` is set by default.

## Usage Examples

After configuring a `client`, you can run the following examples.

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
* create volume
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
* floating ip detach
* floating ip name

### Compose

* compose create
* compose up
* compose down
* compose rm

### Snapshot

* create snapshot

### Service

* create service
* remove service
* inspect service
* list services

### Func (beta)

* create func
* remove func
* list funcs
* func status
* call func

### Misc.

* version
* info

### Security Groups

wip

### Event

wip

### Cron (beta)

wip

## Contributing

Bug reports and pull requests are welcome at https://github.com/drish/hyperb.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

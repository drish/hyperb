# API

Other examples: [Authenticating in GCR](https://github.com/drish/hyperb/blob/master/examples/auth-gcr-registry.md), [Streaming Logs](https://github.com/drish/hyperb/blob/master/examples/streaming-logs.md), [Streaming-stats](https://github.com/drish/hyperb/blob/master/examples/streaming-stats.md)

## Images API

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

Authenticating in a third party docker registry, you must provide a AuthObject.

Example with gcr, [service account](https://cloud.google.com/container-registry/docs/advanced-authentication) :

```ruby

x_registry_auth = {
  username: '_json_key',
  password: File.new('./path/to/service-account.json'),
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

## Containers API

#### create_container

Return a hash containing downcased symbolized container info.


```ruby
res = client.create_container name 'nginx-c', image: 'nginx', labels: { sh_hyper_instancetype: 'm1' }
```

```ruby
res = client.create_container name 'nginx-c', image: 'nginx', hostname: 'nginx-hostname'
```

```ruby
res = client.create_container name 'nginx-c', image: 'nginx', cmd: "echo 'something'"
```

```ruby
res = client.create_container name 'nginx-c', image: 'nginx', hostname: 'hostny', entrypoint: './entrypoint.sh'
```

#### start_container

```ruby
client.start_container id: 'nginx'
```

#### stop_container

```ruby
client.stop_container id: 'nginx'
```

```ruby
client.stop_container id: 'nginx', t: 30
```

#### remove_container

Simple remove

```ruby
client.remove_container id: 'nginx'
```

Force remove, and remove all attached volumes.

```ruby
client.remove_container id: 'nginx', force: true, v: true
```

#### inspect_container

Return a hash containing downcased symbolized container info.

```ruby
data = client.inspect_container id: 'rails-server'
puts data
```

Include size information

```ruby
data = client.inspect_container id: 'rails-server', size: true
puts data
```

#### container_logs

Returns a streamable HTTP:Response::Body object

Simple logs

```ruby
logs = client.container_logs id: 'rails-server', stderr: true, stdout: true, tail: 100
puts logs
```

Streaming

```ruby
logs = client.container_logs id: 'rails-server', stdout: true, follow: true

while body = logs.readpartial(1024)
  puts body
end
```

Include size information

```ruby
data = client.inspect_container id: 'rails-server', size: true
puts data
```

#### container_stats

Returns a streamable HTTP:Response::Body object

Get stats at the time of the request

```ruby
stats = client.container_stats id: 'django-server'
puts stats
```

Streaming stats at real time

```ruby
logs = client.container_logs id: 'rails-server', stream: true

while body = logs.readpartial(1024)
  puts body
end
```

## Volumes API

#### remove_volume

```ruby
client.remove_volume id: 'volume-name'
```

#### inspect_volume

```ruby
client.inspect_volume id: 'volume-id'
```

## Fips API

TODO

## Events API

TODO

## Network API

TODO

## Snapshot API

TODO


## Misc.

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
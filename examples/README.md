# API

Other examples: [Authenticating in GCR](https://github.com/drish/hyperb/blob/master/examples/auth-gcr-registry.md), [Streaming Logs](https://github.com/drish/hyperb/blob/master/examples/streaming-logs.md), [Streaming stats](https://github.com/drish/hyperb/blob/master/examples/streaming-stats.md)

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

return a [HTTP::Response::Body](http://www.rubydoc.info/gems/http/HTTP/Response/Body), which can be streamed.

```ruby
response = client.create_image from_image: 'busybox'
puts response
```

```ruby
response = client.create_image(from_image: 'busybox')
while body = response.readpartial(1024)
  puts body
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

response = client.create_image(from_image: 'gcr.io/private/repo/image', x_registry_auth: x_registry_auth)
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
res = client.create_container name: 'nginx-c', image: 'nginx', labels: { sh_hyper_instancetype: 'm1' }
```

With hostname

```ruby
res = client.create_container name: 'nginx-c', image: 'nginx', hostname: 'nginx-hostname'
```

With custom cmd

```ruby
res = client.create_container name: 'nginx-c', image: 'nginx', cmd: "echo 'something'"
```

With custom entrypoint

```ruby
res = client.create_container name: 'nginx-c', image: 'nginx', hostname: 'hostny', entrypoint: './entrypoint.sh'
```

With custom mounts

```ruby
res = client.create_container name: 'nginx-c', image: 'nginx', mounts: ['./path/to/mount']'
```

With custom network mode

```ruby
res = client.create_container name: 'nginx-c', image: 'nginx', networkmode: 'bridge'
```

Exposing ports

```ruby
res = client.create_container name: 'nginx-c', image: 'nginx', exposedports: { '22/tcp': {} }
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

Returns a streamable [HTTP:Response::Body](http://www.rubydoc.info/gems/http/HTTP/Response/Body) object

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

Returns a streamable [HTTP:Response::Body](http://www.rubydoc.info/gems/http/HTTP/Response/Body) object

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

#### kill_container

```ruby
client.kill_container id: 'django-server'
```

```ruby
client.kill_container id: 'django-server', signal: 'sigterm'
```

#### rename_container

```ruby
client.rename_container id: 'django-server', name: 'its-actually-a-rails-server'
```

## Volumes API

#### remove_volume

```ruby
client.remove_volume id: 'volume-name'
```

#### inspect_volume

Return a Hash of downcase symbolized json response.

```ruby
volume_info = client.inspect_volume id: 'volume-id'
puts volume_info
```

#### volumes

returns an Array of Hyperb::Volume

```ruby
volumes = client.volumes
puts volumes
```

## Network API

#### fip_allocate

Returns an array of allocated ips

Allocate `count` ips.

```ruby
client.fip_allocate count: 1
```

#### fip_release

```ruby
client.fip_release ip: '8.8.8.8'
```

#### fips_ls

Returns an array of floating ip objects

```ruby
client.fips_ls
```

#### fip_name

```ruby
client.fip_name ip: '8.8.8.8', name: 'proxy'
```

#### fip_detach

```ruby
client.fip_detach container: 'nginx'
```

#### fip_attach

```ruby
client.fip_attach ip: '8.8.8.8', container: 'nginx'
```

## Events API

wip

## Compose API

See [compose API examples](https://github.com/drish/hyperb/blob/master/examples/compose.md)

## Services API

#### create_service

Returns a Hash of downcased symbolized json response

```ruby
options = {
	name: 'srvc1', # required
	image: 'nginx', # required
	replicas: 1, # required
	service_port: 80, # required
	container_port: 80,
	labels: { # required
    'app': 'web1'
  },
	cmd: 'command',
	entrypoint: 'entry.sh',
	env: ['env=123', 'env2=456'],
	protocol: 'https',
	algorithm: 'roundrobin'
}

srvc = client.create_service(options)
puts srvc
````

#### remove_service

```ruby
client.remove_service name: 'srvc1'
````

```ruby
client.remove_service name: 'srvc1', keep: true
````

## Snapshot API

Return hash containing snapshot information

```ruby
snapshot = client.create_snapshot name: 'snappy', volume: 'volumeId'
```

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
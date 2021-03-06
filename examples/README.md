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
info = client.inspect_image(name: 'busybox')
puts info
```

## [Containers API](https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Container)

#### [create_container](https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Container/create.html)

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
res = client.create_container name: 'nginx-c', image: 'nginx', mounts: ['./path/to/mount']
```

With custom network mode

```ruby
res = client.create_container name: 'nginx-c', image: 'nginx', networkmode: 'bridge'
```

Exposing ports

```ruby
res = client.create_container name: 'nginx-c', image: 'nginx', exposedports: { '22/tcp': {} }
```

Configurations such as:

Binds, Links, PublishAllPorts,  PortBindings, ReadonlyRootfs, VolumesFrom, RestartPolicy, NetworkMode, LogConfig, VolumeDriver

Are setup through Hyperb::HostConfig.

see examples below:

```ruby
# you can either create host configurations through Hyperb::HostConfig
# or with a Hash

client.create_container name: 'mysql-1', image: 'mysql', host_config: Hyperb::HostConfig.new(binds: ['/path'] )}

client.create_container name: 'mysql-1', image: 'mysql', host_config: { binds: ['/path/'] }
client.create_container name: 'mysql-1', image: 'mysql', host_config: { links: ['container1:link_alias'] }
client.create_container name: 'mysql-1', image: 'mysql', host_config: { publish_all_ports: true }
client.create_container name: 'mysql-1', image: 'mysql', host_config: { readonly_rootfs: true }
client.create_container name: 'mysql-1', image: 'mysql', host_config: { restart_policy: { name: 'unless-stopped' }}
client.create_container name: 'mysql-1', image: 'mysql', host_config: { network_mode: 'host' }
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
logs = client.container_stats id: 'rails-server', stream: true

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

#### create_volume

Returns a Hash containing volume information

```ruby
vol = client.create_volume name: 'vol'
# creates default (10gb) volume
{:name=>"vol", :driver=>"hyper", :mountpoint=>"", :labels=>{:size=>"10", :snapshot=>""}, :scope=>"", :createdat=>"0001-01-01T00:00:00Z"}
```

```ruby
vol = client.create_volume name: 'vol1', size: 35
# creates a 35GB size volume
{:name=>"vol1", :driver=>"hyper", :mountpoint=>"", :labels=>{:size=>"35", :snapshot=>""}, :scope=>"", :createdat=>"0001-01-01T00:00:00Z"}
```

```ruby
vol = client.create_volume name: 'vol1', snapshot: 'dddeeefff'
# creates a volume based on a snapshot
{:name=>"vol1", :driver=>"hyper", :mountpoint=>"", :labels=>{:size=>"10", :snapshot=>"dddeeefff"}, :scope=>"", :createdat=>"0001-01-01T00:00:00Z"}
```

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

#### services

Returns an Array of downcased symbols

```ruby
client.services
```

#### inspect_service

Returns an Hash containing service fields

```ruby
client.inspect_service(name: 'srvc1')
```

## [Funcs API](https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Func)

#### [create_func](https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Func/create.html)

Return hash containing func information

```ruby

func_config = {
  name: "helloworld",
  config: {
    cmd: [
      "echo",
      "HelloWorld"
    ],
    image: "ubuntu"
  }
}

func = client.create_func(func_config)
puts func
```

#### [remove_func](https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Func/remove.html)

```ruby
client.remove_func name: 'func1'
```

#### [funcs](https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Func/list.html)

Returns an array of Hyperb::Func

```ruby
funcs = client.funcs
funcs.is_a?(Array)

puts funcs.first.name
```

#### [call_func](https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Func/call.html)

Returns a JSON response containing `CallId` or function return value

```ruby
client.call_func(name: 'fn', uuid: 'uuid')
# {CallId: ""}

client.call_func(name: 'helloworld1', uuid: 'uuid', sync: true)
# HelloWorld
```

#### [remove_func](https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Func/remove.html)

```ruby
client.remove_func(name: 'fn')
```

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

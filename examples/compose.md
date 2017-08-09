## Usage examples of compose

Assuming you already configured your client.

All compose methods returns a streamable [HTTP::Response::Body]() object

**Create a Hash representing a [compose file](https://docs.hyper.sh/Reference/compose_file_ref.html) services block**

```ruby
services = {
  'db': {
    'environment': [
      "MYSQL_ROOT_PASSWORD=my-secret-pw"
    ],
    'external_links': nil,
    'image': 'mysql:latest'
  },
  'web': {
    'depends_on': [
			'db'
		],
		'external_links': nil,
		'image': 'wordpress:latest',
		'links': ['db:mysql']
	}
}
```

after setting up a service hash, you may use up, or create.

```ruby
up = client.compose_up project: 'wp', serviceconfigs: services

while body = up.readpartial(1024)
	puts body
end

create = client.compose_create project: 'wp2', serviceconfigs: services
create = client.compose_create project: 'wp2', serviceconfigs: services, norecreate: true
create = client.compose_create project: 'wp2', serviceconfigs: services, forcerecreate: true

while body = create.readpartial(1024)
	puts body
end
```

**Stoping and removing a compose project (down)**

```ruby
client.compose_down project: 'wp'
```

```ruby
client.compose_down project: 'wp', rmi: true
```

```ruby
client.compose_down project: 'wp', rmorphans: true
```

```ruby
client.compose_down project: 'wp', vol: true
```

**Deleting a compose project**

```ruby
client.compose_rm project: 'wp'
```

**remove all attached volumes**

```ruby
client.compose_rm project: 'wp', rmvol: true
```

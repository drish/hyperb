## Handling errors

Hyperb has set of exceptions representing Hyper.sh errors.

#### Hyperb::Errors::Unauthorized

raised when credentials are invalid

#### Hyperb::Errors::NotFound

raised when resource can't be found

#### Hyperb::Errors::InternalServerError

raised when hyper.sh server returns 500

#### Hyperb::Errors::Conflict

usually when a container or image can't be deleted or stopped for some reason.

#### Hyperb::Errors::NotModified

usually when a container can't be stopped because it was already stopped.

Examples:

```ruby

begin
  stats = client.container_stats id: 'nginxy', stream: true

  while body = stats.readpartial(1024)
    puts body
  end

rescue Exception => e
  puts 'got something'
  puts e.message
end
```

```ruby

begin
  stats = client.container_stats id: 'nginxy', stream: true

  while body = stats.readpartial(1024)
    puts body
  end

rescue Hyperb::Errors::NotFound => e
  puts 'container not found'
end
```
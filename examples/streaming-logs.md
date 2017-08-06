## Streaming container_logs

Assuming you already configured your client, and you have a running container.

Hyperb uses [httprb](https://github.com/httprb/http) as the underlying http client, it supports streaming by default,
by calling the `readpartial`

For continuous streaming of the logs, use `follow: true`

Example:

```ruby

logs = client.container_logs id: 'nginx', stdout: true, stderr: true, follow: true

while body = logs.readpartial(1024)
  puts body
end

```

```ruby

logs = client.container_logs id: 'nginx', stdout: true, stderr: true, tail: 30

puts logs

```
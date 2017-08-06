## Streaming container_stats

Assuming you already configured your client, and you have a running container.

For continuous streaming of the stats, use `stream: true`

Examples:

```ruby
# stream by default
stats = client.container_stats id: 'nginx'

while body = stats.readpartial(1024)
  puts body
end

```

```ruby

stats = client.container_stats id: 'nginx', stream: false

puts stats

```
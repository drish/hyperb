## Authenticating in GCR

Assuming you already setup google cloud and you have in hands a [service account](https://cloud.google.com/container-registry/docs/advanced-authentication)

Example:

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
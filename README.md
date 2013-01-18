# Minecraft::JSONAPI

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'minecraft-jsonapi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install minecraft-jsonapi

## Usage

```ruby
api = Minecraft::JSONAPI.new(host: "123.45.6.78", port: 20059, username: "admin", password: "12345", salt: "makestheworldtastebetter")

api.sendMessage "Dinnerbone", "Hello, Dinnerbone!"

api.permissions do |perms|
	perms.addPlayerToGroup "Fustrate", "Jolly Good Fellows"
	groups = perms.getGroups
end

percent_disk_usage = api.system do |system|
	system.getDiskUsage / system.getDiskSize
end

players_online = api.getPlayerCount
players_limit = api.getPlayerLimit
api.banWithReason "Nardageddon", "For excessive use of jungle planks."
api.reloadServer
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

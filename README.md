# EasyPostgis

EasyPostgis is a gemification of the code described in Nick Gauthier's 2013 blog post 
['PostGIS and Rails: A Simple Approach'][1]. 

It adds 2 scopes to your model: 

* near(point, distance_in_meters)
* with_distance(point)

*near* filters the rows based on distance from the point.
*with_distance* adds a distance column to the result.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'easy_postgis'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install easy_postgis

## Usage

```ruby
  class Address
    # has lat and lng attributes 
    include EasyPostgis
  end
  
  some_address = Address.first
  near_by_addresses = Address.near(some_address, 500) # Addresses within 500 meters
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/easy_postgis. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


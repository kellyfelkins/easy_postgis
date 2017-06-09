# EasyPostgis

EasyPostgis is a gemification of the code described in Nick Gauthier's 2013 blog post 
['PostGIS and Rails: A Simple Approach'][1]. 

[1]: http://ngauthier.com/2013/08/postgis-and-rails-a-simple-approach.html

It creates 2 scopes for use by your model: 

* near(point, distance_in_meters)
* with_distance(point)

*near* filters the rows based on distance from the point.
*with_distance* adds a distance column to the result.

```ruby
# find the node closest to a lat lon
def self.nearest_node(lat, lng)
  point = OpenStruct.new(:lat => lat, :lng => lng)
  Node.with_distance(point).order("distance").first # use quoted string rather than symbol for 
                                                    # distance so that rails does not append 
                                                    # a table name
end
```

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

Add the postgis extension and create the index for your table in a migration:

```ruby
class AddPostgis < ActiveRecord::Migration
  def up
    execute 'create extension postgis'
    execute %{
      create index index_on_node_location on nodes using gist (
        ST_GeographyFromText(
          'SRID=4326;POINT(' || nodes.lng || ' ' || nodes.lat || ')'
        )
      )
    }
  end

  def down
    execute %{drop index index_on_node_location}
  end
end
```

Include EasyPostgis in your model:

```ruby
  class Address
    # has lat and lng attributes 
    include EasyPostgis
  end
  
  some_address = Address.first
  near_by_addresses = Address.near(some_address, 500) # Addresses within 500 meters
```

## Development

TODO:
  
  * you must create the test database to run the tests: psql> create database easy_postgis_test;
  * you must add gis: psql> create extension postgis;
  * we should allow for customization of the lat/lng column names
  * we should provide a generator to create a migration that adds the index
  
After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/easy_postgis. 

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


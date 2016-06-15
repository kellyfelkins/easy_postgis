require 'minitest/autorun'
require "active_record"
require "atv"
require_relative '../lib/easy_postgis'

describe EasyPostgis do
  describe '.near' do
    it 'finds near records, but not far records' do
      @data_as_table = <<TEXT
|-----------------------------------+------------+--------------+--------------------|
| address                           |   latitude |    longitude |             meters |
|-----------------------------------+------------+--------------+--------------------|
| 2234 Noriega St, San Francisco CA |  37.753885 |  -122.487606 |                  0 |
| 1684 30th St, San Francisco CA    | 37.7559047 | -122.4884078 | 235.38311618596654 |
| 1664 30th St, San Francisco CA    |  37.756249 |  -122.488412 |  272.2479269205636 |
| 1538 30th St, San Francisco CA    |  37.758535 |  -122.488579 |  524.0843047808801 |
| 1527 30th Ave, San Francisco CA   |  37.758748 |  -122.488938 |    553.27501274471 |
| 2458 Judah St, San Francisco CA   | 37.7612171 | -122.4883411 |  817.8495073404802 |
| 2818 Piedmont Ave, Berkeley CA    |  37.859609 |  -122.251391 | 23850.743325575488 |
|-----------------------------------+------------+--------------+--------------------|
TEXT

      DATABASE_CONFIG_PATH = File.dirname(__FILE__) << "/database.yml"
      class Address < ActiveRecord::Base
        establish_connection YAML.load_file(DATABASE_CONFIG_PATH)
        include EasyPostgis
      end
      begin
        Address.connection.create_table(:addresses) do |t|
          t.column :lat, :decimal, :precision => 15, :scale => 10
          t.column :lon, :decimal, :precision => 15, :scale => 10
          t.column :address, :string
        end
        Address.connection.execute <<SQL
create index point_index ON addresses using gist (
  ST_GeographyFromText(
    'SRID=4326;POINT(' || addresses.lon || ' ' || addresses.lat || ')'
  )
)
SQL
      rescue ActiveRecord::StatementInvalid
      end
      Address.connection.execute('TRUNCATE TABLE addresses')
      atv = ATV.new(StringIO.new(@data_as_table))
      atv.each do |row|
        Address.create!(
          :lat => row['latitude'],
          :lon => row['longitude'],
          :address => row['address']
        )
      end

      primary_address = Address.where(:address => '2234 Noriega St, San Francisco CA').take!
      distance_relation = Address.w_distance(primary_address).near(primary_address, 304.8)
      near_addresses = distance_relation.all

      near_addresses.map(&:address).must_equal([
                                  '2234 Noriega St, San Francisco CA',
                                  '1684 30th St, San Francisco CA',
                                  '1664 30th St, San Francisco CA'
                                ])

    end
  end
end

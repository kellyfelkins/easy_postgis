require "easy_postgis/version"

module EasyPostgis
  extend ActiveSupport::Concern

  included do
    scope :near, -> (other, distance_in_meters) { where(near_sql(other, distance_in_meters)) }
    scope :with_distance, ->(point) { select("#{table_name}.*, #{distance_select_sql(point)}") }
  end

  class_methods do
    def near_sql(other, distance_in_meters)
      "ST_DWithin(#{geography_from_table},#{geography_from_point(other.lng,other.lat)},%d)" % [distance_in_meters]
    end

    def distance_select_sql(other)
      "ST_Distance(#{geography_from_table},#{geography_from_point(other.lng,other.lat)}) as distance"
    end

    def geography_from_table
      "ST_GeographyFromText('SRID=4326;POINT(' || #{table_name}.lng || ' ' || #{table_name}.lat || ')')"
    end

    def geography_from_point(lon, lat)
      "ST_GeographyFromText('SRID=4326;POINT(%f %f)')" % [lon, lat]
    end
  end
end
